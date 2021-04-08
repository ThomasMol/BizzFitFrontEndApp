import 'package:bizzfit/authentication/login_page.dart';
import 'package:bizzfit/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'api.dart';
import 'authentication/login_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

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
      CustomWidgets.showMessage(response['message'], context);
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
      if (response['status'] == 'Success') {     
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false);
    } else if (response['status'] == 'Error') {
      CustomWidgets.showMessage(response['message'], context);
    }
  }
}
