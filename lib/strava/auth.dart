// Strava api oauth2.0
import 'package:oauth2_client/oauth2_client.dart';
import 'secrets.dart';

class StravaOAuth2Client extends OAuth2Client {
  StravaOAuth2Client(): super(
    authorizeUrl: 'https://www.strava.com/oauth/mobile/authorize', //Your service's authorization url
    tokenUrl: 'https://www.strava.com/api/v3/oauth/token?client_id=65296&client_secret=823fd5215c7137ab7859a72a79435abc348e7449', //Your service access token url
    customUriScheme: 'com.bizzfit.app',
    redirectUri: 'com.bizzfit.app://oauth2redirect'
  );
}