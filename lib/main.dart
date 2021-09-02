import 'package:bizzfit/pages/splash_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://najmocrkpfatcufsfwuq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYzMDU5Mjc0MSwiZXhwIjoxOTQ2MTY4NzQxfQ.qv7lyYb1UK4RjtToPzOiY8n6svcPtKAX_GsvOpZnFAs',
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
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
            primaryColor: Colors.white,
            accentColor: Colors.orangeAccent,
            indicatorColor: Colors.orangeAccent.shade400,
            textTheme: TextTheme(
                headline1: TextStyle(color: Colors.deepOrange.shade900))));
  }
}
