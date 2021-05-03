import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:url_launcher/url_launcher.dart';
import 'authentication/login_page.dart';
import 'utils.dart';
import 'api.dart';
import 'strava/secrets.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'strava/auth.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  static const title = 'Profile';
  static const icon = Icon(CupertinoIcons.person_fill);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<dynamic> futureProfile;
  @override
  void initState() {
    super.initState();
    futureProfile = fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    final builderProfile = FutureBuilder<dynamic>(
        future: futureProfile,
        builder: (context, snapshot) {
          Widget newsListSliver;
          if (snapshot.hasData) {
            newsListSliver = Column(children: [
              Image(
                image: AssetImage('assets/profile.png'),
                height: 120,
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              Text(snapshot.data['first_name'] +
                  ' ' +
                  snapshot.data['last_name']),
              Padding(padding: EdgeInsets.symmetric(vertical: 20)),
              const Divider(
                height: 2.0,
              ),
              ListTile(
                leading: Icon(CupertinoIcons.list_number),
                title: Text(snapshot.data['score'].toString()),
                subtitle: Text('points'),
              ),
              const Divider(
                height: 2.0,
              ),
              ListTile(
                leading: Icon(CupertinoIcons.briefcase_fill),
                title: Text(snapshot.data['org_name']),
                subtitle: Text('Organization'),
              ),
              const Divider(
                height: 2.0,
              ),
              ListTile(
                leading: Icon(CupertinoIcons.list_number),
                title: Text(snapshot.data['org_score'].toString()),
                subtitle: Text('Your organization\'s score'),
              ),
              const Divider(
                height: 2.0,
              ),
              ListTile(
                leading: Icon(Icons.api),
                title: Text('Connect with your Strava account'),
                trailing: Icon(CupertinoIcons.chevron_forward),
                onTap: openStravaAuth,
              ),
              const Divider(
                height: 2.0,
              ),
              ListTile(
                leading: Icon(Icons.api),
                title: Text('Get strava data (test)'),
                trailing: Icon(CupertinoIcons.chevron_forward),
                onTap: getStravaData,
              ),
              const Divider(
                height: 2.0,
              ),
              ListTile(
                leading: Icon(Icons.api),
                title: Text('Connect with your Nike Run Club account'),
                trailing: Icon(CupertinoIcons.chevron_forward),
              ),
              const Divider(
                height: 2.0,
              ),
            ]);
          } else {
            newsListSliver = Center(
              child: CupertinoActivityIndicator(),
            );
          }
          return newsListSliver;
        });

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(),
        child: SafeArea(
            child: Material(
                child: Column(
          children: [
            builderProfile,
            Spacer(),
            ListTile(
              title: Text('Logout'),
              onTap: _logOut,
            ),
            const Divider(
              height: 2.0,
            ),
          ],
        ))));
  }

  Future<dynamic> fetchProfile() async {
    var response = await CallApi().getRequest(null, '/user');
    if (response['status'] == 'Success') {
      return response['data'];
    } else if (response['status'] == 'Error') {
      Utils.showMessage(response['message'], context);
    }
  }

  void reloadData() {
    setState(() {
      futureProfile = fetchProfile();
    });
  }

  void _logOut() async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    var response = await CallApi().postRequest(null, '/auth/logout');
    await storage.delete(key: 'access_token');
    await storage.delete(key: 'permission_level');

    // TODO tokens should be removed, but only if user has authed with particular api
    /* StravaOAuth2Client stravaOAuth2Client = StravaOAuth2Client();
    OAuth2Helper oAuth2Helper = OAuth2Helper(stravaOAuth2Client,
        grantType: OAuth2Helper.AUTHORIZATION_CODE,
        clientId: clientId,
        clientSecret: secret,
        scopes: ['activity:read_all']);
    await oAuth2Helper.removeAllTokens(); */

    if (response['status'] == 'Success') {
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false);
    } else if (response['status'] == 'Error') {
      Utils.showMessage(response['message'], context);
    }
  }

  void openStravaAuth() {
    StravaOAuth2Client stravaOAuth2Client = StravaOAuth2Client();

    OAuth2Helper oAuth2Helper = OAuth2Helper(stravaOAuth2Client,
        grantType: OAuth2Helper.AUTHORIZATION_CODE,
        clientId: stravaClientId,
        clientSecret: stravaSecret,
        scopes: ['activity:read_all']);
    oAuth2Helper.getToken();
  }

  void getStravaData() async {
    StravaOAuth2Client stravaOAuth2Client = StravaOAuth2Client();
    OAuth2Helper oAuth2Helper = OAuth2Helper(stravaOAuth2Client,
        grantType: OAuth2Helper.AUTHORIZATION_CODE,
        clientId: stravaClientId,
        clientSecret: stravaSecret,
        scopes: ['activity:read_all']);
    http.Response response = await oAuth2Helper
        .get('https://www.strava.com/api/v3/athlete/activities');
    print(jsonDecode(response.body)[0]);
  }
}
