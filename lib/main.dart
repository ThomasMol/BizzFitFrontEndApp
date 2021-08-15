import 'package:bizzfit/pages/splash_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://yqewjyiksmtrmdpbvjtx.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYyODkzODcxNSwiZXhwIjoxOTQ0NTE0NzE1fQ.MmnlfZcxFflPALmQ7EoFoeJ7fBmhsp1h7sJ_SmAhGus',
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: SplashPage(),
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
                headline1: TextStyle(color: Colors.deepOrange.shade900))));
  }
}
