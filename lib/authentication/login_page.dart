import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../api.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../main_layout.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<StatefulWidget> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Center(
            child: ListView(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.fromLTRB(50, 100, 50, 20),
            child: Text('Login to BizzFit')),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
            child: CupertinoTextField(
              controller: _emailController,
              placeholder: 'Email',
            )),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
            child: CupertinoTextField(
              obscureText: true,
              controller: _passwordController,
              placeholder: 'Password',
            )),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 50),
            child: _isLoading
                ? CupertinoActivityIndicator()
                : CupertinoButton(
                    child: Text('Login'), onPressed: _handleLogin)),
      ],
    )));
  }

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    var data = {
      'email': _emailController.text,
      'password': _passwordController.text
    };
    var res = await CallApi().postData(data, '/auth/login');
    var body = json.decode(res.body);
    print(body['status']);
    if (body['status'] == 'Success') {
      FlutterSecureStorage storage = FlutterSecureStorage();
      await storage.write(key: 'access_token', value: body['data']['token']);

      Navigator.of(context, rootNavigator: true).push<void>(CupertinoPageRoute(
        builder: (context) => HomeScreen(),
      ));
    } else if(body['status'] == 'Error') {
      //TODO Handle status is error

    } else {
      // Handle when there is no error or no success (probably when server is not online or something)
    }

    setState(() {
      _isLoading = false;
    });
  }
}
