import 'package:flutter/cupertino.dart';
import 'api.dart';
import 'dart:convert';

class Profile extends StatefulWidget {
  static const title = 'Profile';
  static const icon = Icon(CupertinoIcons.person_fill);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(),
        child: SafeArea(
          child: Padding(
              padding: EdgeInsets.all(30),
              child: CupertinoButton(
                  child: Text('Test'), onPressed: _retrieveProfileData)),
        ));
  }

  void _retrieveProfileData() async {
    var res = await CallApi().getData(null, '/user');
    print(res);
    return null;
  }
}
