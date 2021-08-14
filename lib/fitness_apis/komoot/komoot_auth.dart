//komoot api oath2.0
import 'package:oauth2_client/oauth2_client.dart';
import 'secrets.dart';

class KomootOAuth2Client extends OAuth2Client {
  KomootOAuth2Client(): super(
      authorizeUrl: 'https://auth.komoot.de/oauth/authorize', //Your service's authorization url
      tokenUrl: 'https://auth.komoot.de/oauth/token', //Your service access token url
      customUriScheme: 'com.bizzfit.app',
      redirectUri: 'com.bizzfit.app://oauth2redirect'
  );
}