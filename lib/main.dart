import 'package:bizzfit/authentication/login_page.dart';
import 'package:flutter/cupertino.dart';
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
  bool _isLoggedIn = false;

  @override
  void initState() {
    _checkIfLoggedIn();
    super.initState();
  }

  void _checkIfLoggedIn() async {
    // Get token value
    FlutterSecureStorage storage = FlutterSecureStorage();
    String token = await storage.read(key: 'access_token');

    if (token != null) {
      setState(() {
        _isLoggedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
        home: _isLoggedIn ? HomeScreen() : LoginPage(),
        title: 'BizzFit',
        theme: CupertinoThemeData(       
          primaryColor: CupertinoColors.activeOrange,    
            textTheme: CupertinoTextThemeData(
                primaryColor: CupertinoColors.systemBlue)));
  }
}
