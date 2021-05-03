import 'package:bizzfit/authentication/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'main_layout.dart';

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
            return CupertinoApp(
                home: snapshot.data ? HomeScreen() : LoginPage(),
                title: 'BizzFit',
                localizationsDelegates: [
                  DefaultMaterialLocalizations.delegate,
                  DefaultCupertinoLocalizations.delegate,
                  DefaultWidgetsLocalizations.delegate,
                ],
                theme: CupertinoThemeData(
                    primaryColor: CupertinoColors.activeOrange,
                    textTheme: CupertinoTextThemeData(
                        primaryColor: CupertinoColors.systemBlue)));            
          } else {
           return CupertinoApp(
              home: Scaffold(
                  body: Center(
                child: CupertinoActivityIndicator(),
              )),
              title: 'BizzFit loading...',
            );
          }
        });
  }

  Future<bool> checkIfLoggedIn() async {
    // Get token value
    FlutterSecureStorage storage = FlutterSecureStorage();
    String token = await storage.read(key: 'access_token');
    // TODO cross check if token is also in database (access_token table in db),
    // otherwise access token in local secure storage should be deleted from storage
    // and new login attempt should be made

    if (token != null) {
      return true;
    } else {
      return false;
    }
  }
}
