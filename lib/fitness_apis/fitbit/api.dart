import 'dart:convert';
import 'package:bizzfit/fitness_apis/fitbit/fitbit_oauth2_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
        scopes: ['activity','profile']);
  }

  void storeAuth() async {
    http.Response response =
        await oAuth2Helper.get('https://api.fitbit.com/1/user/-/profile.json');
    print(jsonDecode(response.body)['user']);
    if (response.statusCode == 200) {
      final secureStorage = FlutterSecureStorage();
      secureStorage.write(
          key: 'fitbit_authenticated',
          value: jsonDecode(response.body)['user']['encodedId'].toString());
    } else {
      print(response.body);
    }
  }

  void removeAuth() async {
    oAuth2Helper.removeAllTokens();
    final secureStorage = FlutterSecureStorage();
    secureStorage.delete(key: 'fitbit_authenticated');
  }
}
