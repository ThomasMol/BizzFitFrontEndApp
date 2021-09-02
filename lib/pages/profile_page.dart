import 'package:bizzfit/auth_required_state.dart';
import 'package:bizzfit/constants.dart';
import 'package:bizzfit/fitness_apis/fitbit/api.dart';
import 'package:bizzfit/fitness_apis/strava/api.dart';
import 'package:bizzfit/models/profile.dart';
import 'package:bizzfit/pages/authentication/login_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ProfilePage extends StatefulWidget {
  static const title = 'Profile';
  static const icon = Icon(CupertinoIcons.person_fill);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends AuthRequiredState<ProfilePage> {
  Future<Profile> futureProfile;
  final secureStorage = FlutterSecureStorage();
  bool stravaAuthenticated = false;
  StravaApi stravaApi = StravaApi();
  FitbitApi fitbitApi = FitbitApi();

  @override
  void initState() {
    super.initState();
    futureProfile = fetchProfile();
    stravaAuthenticated =
        secureStorage.read(key: 'strava_authenticated') != null;
  }

  @override
  void onUnauthenticated() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  Future<Profile> fetchProfile() async {
    String userId = supabase.auth.user().id;
    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .limit(1)
        .single()
        .execute();
    if (response.error != null && response.status != 406) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.error.message)));
      return null;
    } else {
      return Profile.fromJson(response.data);
    }
  }

  void reloadData() {
    setState(() {
      futureProfile = fetchProfile();
    });
  }

  void _logOut() async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    final response = await supabase.auth.signOut();
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.error.message),
        backgroundColor: Colors.red,
      ));
    } else {
      await storage.delete(key: 'permission_level');
      if (stravaAuthenticated) {
        stravaApi.removeAuth();
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final builderProfile = FutureBuilder<Profile>(
        future: futureProfile,
        builder: (context, snapshot) {
          Widget newsListSliver;
          if (snapshot.hasData) {
            newsListSliver = Column(children: [
              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              Image(
                image: AssetImage('assets/profile.png'),
                height: 80,
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              Text('${snapshot.data.firstName} ${snapshot.data.lastName}'),
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              const Divider(
                height: 2.0,
              ),
              ListTile(
                leading: Icon(CupertinoIcons.list_number),
                title: Text(snapshot.data.score.toString()),
                subtitle: Text('points'),
              ),              
              const Divider(
                height: 2.0,
              ),
              ListTile(
                leading: Icon(Icons.api),
                title: Text('Connect with your Strava account'),
                trailing: Icon(CupertinoIcons.chevron_forward),
                onTap: stravaApi.storeAuth,
              ),
              const Divider(
                height: 2.0,
              ),
              ListTile(
                leading: Icon(Icons.api),
                title: Text('Remove strava'),
                trailing: Icon(CupertinoIcons.chevron_forward),
                onTap: stravaApi.removeAuth,
              ),
              const Divider(
                height: 2.0,
              ),
              ListTile(
                leading: Icon(Icons.api),
                title: Text('Connect with your fitbit account'),
                trailing: Icon(CupertinoIcons.chevron_forward),
                onTap: fitbitApi.storeAuth,
              ),
              const Divider(
                height: 2.0,
              ),
              ListTile(
                leading: Icon(Icons.api),
                title: Text('Remove fitbit'),
                trailing: Icon(CupertinoIcons.chevron_forward),
                onTap: fitbitApi.removeAuth,
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

    return Scaffold(
        appBar: CupertinoNavigationBar(),
        body: SafeArea(
            child: Material(
                child: ListView(
          children: [
            builderProfile,
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
}
