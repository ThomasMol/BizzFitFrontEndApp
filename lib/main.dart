import 'package:bizzfit/authentication/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Set to false when login system works
  Future<bool> isLoggedIn;
  dynamic permissionLevel = null;
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    isLoggedIn = checkIfLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: isLoggedIn,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return MaterialApp(
                home: snapshot.data
                    ? HomeScreen(permissionLevel: permissionLevel)
                    : LoginPage(),
                title: 'BizzFit',
                localizationsDelegates: [
                  DefaultMaterialLocalizations.delegate,
                  DefaultCupertinoLocalizations.delegate,
                  DefaultWidgetsLocalizations.delegate,
                ],
                theme: ThemeData(
                    primaryColor: Colors.white,
                    accentColor: Colors.orangeAccent,
                    indicatorColor: Colors.orangeAccent.shade400,
                    textTheme: TextTheme(
                        headline1:
                            TextStyle(color: Colors.deepOrange.shade900))));
          } else {
            return MaterialApp(
              home: Scaffold(
                  body: Center(
                child: CupertinoActivityIndicator(),
              )),
              title: 'BizzFit loading...',
            );
          }
        });
  }

  // Check is user is already logged in and set permission level
  Future<bool> checkIfLoggedIn() async {
    String token = await storage.read(key: 'access_token');
    // TODO cross check if token is also in database (access_token table in db),
    // otherwise access token in local secure storage should be deleted from storage
    // and new login attempt should be made
    if (token != null) {
      permissionLevel = int.parse(await storage.read(key: 'permission_level'));
      return true;
    } else {
      return false;
    }
  }
}
