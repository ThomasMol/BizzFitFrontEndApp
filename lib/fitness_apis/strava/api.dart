import 'dart:convert';
import 'package:bizzfit/fitness_apis/strava/strava_oauth2_client.dart';
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
    http.Response response =
        await oAuth2Helper.get('https://www.strava.com/api/v3/athlete');
    if (response.statusCode == 200) {
      final secureStorage = FlutterSecureStorage();
      // subtract duration days: 200 or more to test retrieving data
      int setLastRetrieved = (DateTime.now().millisecondsSinceEpoch / 1000).floor();
      secureStorage.write(
          key: 'strava_authenticated',
          value: jsonDecode(response.body)['id'].toString());
      secureStorage.write(
          key: 'strava_last_retrieved',
          value: setLastRetrieved.toString());
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
}
