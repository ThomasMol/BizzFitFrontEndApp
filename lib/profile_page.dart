import 'package:buzzfit/authentication/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'api.dart';
import 'dart:convert';
import 'authentication/login_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Profile extends StatefulWidget {
  static const title = 'Profile';
  static const icon = Icon(CupertinoIcons.person_fill);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(),
        child: SafeArea(
          child: Padding(
              padding: EdgeInsets.all(30),
              child:
                  CupertinoButton(child: Text('Logout'), onPressed: _logOut)),
        ));
  }

  void _retrieveProfileData() async {
    var res = await CallApi().getRequest(null, '/user');
    return res;
  }

  void _logOut() async {
    var response = await CallApi().postRequest(null, '/auth/logout');

    if (response['status'] == 'Success') {
      await storage.delete(key: 'access_token');

      Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false
        );
      

    } else if (response['status'] == 'Error') {
      //TODO Handle status is error

    } else {
      // Handle when there is no error or no success (probably when server is not online or something)
    }

    return response['data']['message'];
  }
}
