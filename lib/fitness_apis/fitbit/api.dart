import 'dart:convert';
import 'package:bizzfit/constants.dart';
import 'package:bizzfit/fitness_apis/fitbit/fitbit_oauth2_client.dart';
import 'package:bizzfit/models/fitbit_activity_log.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:http/http.dart' as http;

class FitbitApi {
  final secureStorage = FlutterSecureStorage();
  final String fitbitSecret = "379d69cf4848e025349b0548e456c9ee";
  final String fitbitClientId = "23B5BV";
  final String redirectUrlMobile = "com.bizzfit.app://oauth2redirect";
  FitbitOAuth2Client fitbitOAuth2Client;
  OAuth2Helper oAuth2Helper;

  FitbitApi() {
    fitbitOAuth2Client = FitbitOAuth2Client();
    oAuth2Helper = OAuth2Helper(fitbitOAuth2Client,
        grantType: OAuth2Helper.AUTHORIZATION_CODE,
        clientId: fitbitClientId,
        clientSecret: fitbitSecret,
        scopes: ['activity', 'profile']);
  }

  void storeAuth() async {
    http.Response response = await oAuth2Helper
        .get('https://api.fitbit.com/1/user/-/profile.json')
        .catchError((onError) {
      print(onError);
    });
    if (response.statusCode == 200) {
      // subtract duration days: 20 or more to test retrieving data
      String setLastRetrieved = DateFormat('yyyy-MM-dd')
          .format(DateTime.now().subtract(Duration(days: 21)));
      final secureStorage = FlutterSecureStorage();
      secureStorage.write(
          key: 'fitbit_authenticated',
          value: jsonDecode(response.body)['user']['encodedId'].toString());
      await secureStorage.write(
          key: 'fitbit_last_retrieved', value: setLastRetrieved.toString());
      fetchNewActivitiesAndStore();
    } else {
      removeAuth();
    }
  }

  void removeAuth() async {
    oAuth2Helper.removeAllTokens();
    final secureStorage = FlutterSecureStorage();
    secureStorage.delete(key: 'fitbit_authenticated');
  }

  dynamic getData(String url) async {
    http.Response response =
        await oAuth2Helper.get('https://api.fitbit.com/1/user/-/' + url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  void fetchNewActivitiesAndStore() async {
    String lastRetrieved =
        await secureStorage.read(key: 'fitbit_last_retrieved');

    // TODO current fitbit api limits to 20, use the returned pagination object to retrieve more
    var activities = await getData(
        'activities/list.json?afterDate=$lastRetrieved&sort=asc&limit=20&offset=0');
        
    String newLastRetrieved = DateFormat('yyyy-MM-dd').format(DateTime.now());

    await secureStorage.write(
        key: 'fitbit_last_retrieved', value: newLastRetrieved.toString());

    if (activities['activities'].length > 0) {
      List<dynamic> dbActivities = [];
      for (var activity in activities['activities']) {
        FitbitActivities stravaAthleteActivity =
            FitbitActivities.fromJson(activity);
        final dbActivity = {
          'user_id': supabase.auth.user().id,
          'type': stravaAthleteActivity.activityName,
          'time': (stravaAthleteActivity.activeDuration / 1000).floor(),
          'date_time': stravaAthleteActivity.startTime,
          'points': 0
        };
        dbActivities.add(dbActivity);
      }
      final response = await supabase
          .from('physical_activities')
          .insert(dbActivities)
          .execute();
      if (response.error != null && response.status != 406) {
      } else {}
    }
  }
}
