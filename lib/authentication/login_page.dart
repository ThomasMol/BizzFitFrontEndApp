import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../main_layout.dart';
import '../widgets.dart';

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
    return CupertinoPageScaffold(
        child: Center(
            child: ListView(
      children: <Widget>[
        SizedBox(height: 100,),
        Align(alignment: Alignment.center,
            child:  Text('BizzFit',style: TextStyle(fontStyle: FontStyle.italic, fontSize: 40),)),
        Padding(
            padding: EdgeInsets.fromLTRB(50, 50, 50, 10),
            child: Text('Login with your credentials')),
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
      ],
    )));
  }

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    var data = {
      'email': _emailTextController.text,
      'password': _passwordTextController.text
    };
    var response = await CallApi().postRequest(data, '/auth/login');
    if (response['status'] == 'Success') {
      CustomWidgets.showMessage('Succesfully logged in!', context);
      FlutterSecureStorage storage = FlutterSecureStorage();
      await storage.write( key: 'access_token', value: response['data']['token']);
      await storage.write( key: 'permission_level', value: response['data']['user_permission_level'].toString());

      Navigator.of(context, rootNavigator: true)
          .pushReplacement(CupertinoPageRoute(
        builder: (context) => HomeScreen(),
      ));
    } else if (response['status'] == 'Error') {
      CustomWidgets.showMessage(response['message'], context);
    } else {
      // Handle when there is no error or no success (probably when server is not online or something)
    }

    setState(() {
      _isLoading = false;
    });
  }
}
