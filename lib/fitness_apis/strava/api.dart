import 'dart:convert';
import 'package:bizzfit/constants.dart';
import 'package:bizzfit/fitness_apis/strava/strava_oauth2_client.dart';
import 'package:bizzfit/models/strava_athlete_activity.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:http/http.dart' as http;

class StravaApi {
  final secureStorage = FlutterSecureStorage();
  final String stravaSecret = "823fd5215c7137ab7859a72a79435abc348e7449";
  final String stravaClientId = "65296";
  final String redirectUrlMobile = "com.bizzfit.app://oauth2redirect";
  StravaOAuth2Client stravaOAuth2Client;
  OAuth2Helper oAuth2Helper;

  StravaApi() {
    stravaOAuth2Client = StravaOAuth2Client();
    oAuth2Helper = OAuth2Helper(stravaOAuth2Client,
        grantType: OAuth2Helper.AUTHORIZATION_CODE,
        clientId: stravaClientId,
        clientSecret: stravaSecret,
        scopes: ['activity:read_all']);
  }

  void storeAuth() async {
    http.Response response = await oAuth2Helper
        .get('https://www.strava.com/api/v3/athlete')
        .catchError((onError) {
      print(onError);
    });
    if (response.statusCode == 200) {
      final secureStorage = FlutterSecureStorage();
      // subtract duration days: 200 or more to test retrieving data
      int setLastRetrieved = (DateTime.now()
                  .subtract(const Duration(days: 21))
                  .millisecondsSinceEpoch /
              1000)
          .floor();
      await secureStorage.write(
          key: 'strava_authenticated',
          value: jsonDecode(response.body)['id'].toString());
      await secureStorage.write(
          key: 'strava_last_retrieved', value: setLastRetrieved.toString());
      fetchStravaActivities();
    } else {
      removeAuth();
    }
  }

  void removeAuth() async {
    oAuth2Helper.removeAllTokens();
    final secureStorage = FlutterSecureStorage();
    secureStorage.delete(key: 'strava_authenticated');
  }

  dynamic getData(String url) async {
    http.Response response =
        await oAuth2Helper.get('https://www.strava.com/api/v3/' + url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  // Function that will fetch strava activities if user is connected with strava
  // TODO check when last time it was updated, so duplicates cannot happen
  // Checking with last_retrieved almost works: does not work when you remove strava api
  // auth, so users can re auth their strava acc and keep loading their past activities
  void fetchStravaActivities() async {
    var lastRetrieved = await secureStorage.read(key: 'strava_last_retrieved');

    var activities = await getData('athlete/activities?after=' + lastRetrieved);

    int newLastRetrieved =
        (DateTime.now().millisecondsSinceEpoch / 1000).floor();

    await secureStorage.write(
        key: 'strava_last_retrieved', value: newLastRetrieved.toString());

    if (activities.length > 0) {
      List<dynamic> dbActivities = [];
      for (var activity in activities) {
        StravaAthleteActivity stravaAthleteActivity =
            StravaAthleteActivity.fromJson(activity);
        final dbActivity = {
          'user_id': supabase.auth.user().id,
          'type': stravaAthleteActivity.type,
          'time': stravaAthleteActivity.movingTime,
          'date_time': stravaAthleteActivity.startDateLocal,
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
