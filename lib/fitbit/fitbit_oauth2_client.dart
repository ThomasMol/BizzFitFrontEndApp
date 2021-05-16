// Strava api oauth2.0 client
import 'package:oauth2_client/oauth2_client.dart';

class FitbitOAuth2Client extends OAuth2Client {
  FitbitOAuth2Client(): super(
      authorizeUrl: 'https://www.fitbit.com/oauth2/authorize', //Your service's authorization url
      tokenUrl: 'https://api.fitbit.com/oauth2/token', //Your service access token url
      customUriScheme: 'com.bizzfit.app',
      redirectUri: 'com.bizzfit.app://oauth2redirect'
  );
}