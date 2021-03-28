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
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(),
        child: SafeArea(
            child: Scaffold(
                body: FutureBuilder<dynamic>(
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
                            height: 1.0,
                          ),
                          ListTile(
                            title: Text('Org name here'),
                            trailing: Text('Organization'),
                          ),
                          const Divider(
                            height: 1.0,
                          ),
                          Spacer(),
                          const Divider(
                            height: 1.0,
                          ),
                          ListTile(
                            title: Text('Logout'),
                            onTap: _logOut,
                          ),
                          const Divider(
                            height: 1.0,
                          ),
                        ]);
                      } else {
                        newsListSliver = Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return newsListSliver;
                    }))));
  }

  Future<dynamic> fetchProfile() async {
    var response = await CallApi().getRequest(null, '/user');
    if (response['status'] == 'Success') {
      return response['data'];
    } else if (response['status'] == 'Error') {
      CustomWidgets.showMessage(response['message'], context);
    }
  }

  void _logOut() async {
    var response = await CallApi().postRequest(null, '/auth/logout');
    if (response['status'] == 'Success') {
      FlutterSecureStorage storage = FlutterSecureStorage();
      await storage.delete(key: 'access_token');
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false);
    } else if (response['status'] == 'Error') {
      CustomWidgets.showMessage(response['message'], context);
    }
  }
}
