import 'package:bizzfit/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<StatefulWidget> {
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
            child: Text(
                'Register with your email and a password (at least 8 characters)')),
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
                    child: Text('Register'), onPressed: _handleRegistration)),
      ],
    )));
  }

  void _handleRegistration() async {
    setState(() {
      _isLoading = true;
    });

    final response = await supabase.auth
        .signUp(_emailTextController.text, _passwordTextController.text);
        
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.error.message),
        backgroundColor: Colors.red,
      ));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('registered!')));
    }
    setState(() {
      _isLoading = false;
    });
  }
}
