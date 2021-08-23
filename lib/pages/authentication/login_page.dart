import 'package:bizzfit/constants.dart';
import 'package:bizzfit/pages/authentication/register_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../home_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<StatefulWidget> {
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: ListView(
      children: <Widget>[
        SizedBox(
          height: 100,
        ),
        Align(
            alignment: Alignment.center,
            child: Text(
              'BizzFit',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 40),
            )),
        Padding(
            padding: EdgeInsets.fromLTRB(50, 50, 50, 10),
            child: Text(AppLocalizations.of(context).loginPageText)),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
            child: CupertinoTextField(
              controller: _emailTextController,
              keyboardType: TextInputType.emailAddress,
              placeholder: 'Email',
            )),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
            child: CupertinoTextField(
              obscureText: true,
              controller: _passwordTextController,
              placeholder: 'Password',
            )),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 50),
            child: _isLoading
                ? CupertinoActivityIndicator()
                : CupertinoButton.filled(
                    child: Text('Login'), onPressed: _handleLogin)),
        SizedBox(
          height: 25,
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 50),
            child: CupertinoButton(
                child: Text('No account? Register here'),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                })),
      ],
    )));
  }

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    final response = await supabase.auth.signIn(
        email: _emailTextController.text,
        password: _passwordTextController.text);

    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.error.message),
        backgroundColor: Colors.red,
      ));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Logged in!')));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }
}
