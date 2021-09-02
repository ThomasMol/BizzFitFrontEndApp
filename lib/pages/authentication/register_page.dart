import 'package:bizzfit/constants.dart';
import 'package:bizzfit/pages/authentication/login_page.dart';
import 'package:bizzfit/pages/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<StatefulWidget> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  String _selectedOrganization;
  List<DropdownMenuItem<dynamic>> organizationlist = [];

  bool _isLoading = false;

  Future<void> _getOrganizations() async {
    final response = await supabase.from('organizations').select().execute();
    if (response.error != null && response.status != 406) {
      print(response.error);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.error.message)));
    }
    setState(() {
      _selectedOrganization = response.data[0]['id'];
      for (var item in response.data) {
        organizationlist.add(new DropdownMenuItem(
          child: new Text(item['name']),
          value: item['id'],
        ));
      }
    });
  }

  @override
  void initState() {
    _getOrganizations();
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
            child: DropdownButton(
              hint: new Text('Select your organization'),
              items: organizationlist,
              value: _selectedOrganization,
              onChanged: (value) {
                setState(() {
                  _selectedOrganization = value;
                });
              },
              isExpanded: true,
            )),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
            child: CupertinoTextField(
              controller: _firstNameController,
              keyboardType: TextInputType.name,
              placeholder: 'First name',
            )),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
            child: CupertinoTextField(
              controller: _lastNameController,
              keyboardType: TextInputType.name,
              placeholder: 'Last name',
            )),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
            child: CupertinoTextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
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
                : CupertinoButton.filled(
                    child: Text('Register'), onPressed: _handleRegistration)),
        SizedBox(
          height: 25,
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 50),
            child: CupertinoButton(
                child: Text('Already have an account? Login here'),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                })),
      ],
    )));
  }

  void _handleRegistration() async {
    setState(() {
      _isLoading = true;
    });

    final response = await supabase.auth
        .signUp(_emailController.text, _passwordController.text);

    if (response.error != null) {
      print(response.error);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.error.message),
        backgroundColor: Colors.red,
      ));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('registered!')));
      _insertProfile();
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _insertProfile() async {
    final data = {
      'id': supabase.auth.currentUser.id,
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
      'organization_id': _selectedOrganization
    };
    final response = await supabase
        .from('profiles')
        .insert(data, returning: ReturningOption.minimal)
        .execute();
    
    if (response.error != null) {
      print(response.error.message);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.error.message),
        backgroundColor: Colors.red,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully updated profile!')));
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
