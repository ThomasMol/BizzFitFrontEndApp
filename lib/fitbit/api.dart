import 'dart:convert';
import 'package:bizzfit/fitbit/fitbit_oauth2_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:http/http.dart' as http;
import '../utils.dart';

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
        scopes: ['activity']);
  }

  void storeAuth() async {
    http.Response response =
    await oAuth2Helper.get('https://www.fitbit.com/oauth2/authorize');
    if (response.statusCode == 200) {
      final secureStorage = FlutterSecureStorage();
      secureStorage.write(
          key: 'fitbit_authenticated',
          value: jsonDecode(response.body)['id'].toString());
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