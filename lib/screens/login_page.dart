import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  

  bool _obscureText = true;
  String _email='', _password='';
  bool _isSubmitting = false;

  Widget _showTitle() {
    return Text('Login', style: Theme.of(context).textTheme.headline1);
  }

  Widget _showEmailInput() {
    return Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: TextFormField(
            onSaved: (val) => _email = val!,
            validator: (val)  {
              if (val!.isEmpty || !val.contains('@') ) {
                return 'Invalid Email' ;
                    } 
                  return null;
            },
   
            
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
                hintText: 'Enter a valid email',
                icon: Icon(Icons.mail, color: Colors.grey))));
  }

  Widget _showPasswordInput() {
    return Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: TextFormField(
            onSaved: (val) => _password = val!,
            validator: (val) {
              if (val!.isEmpty || val.length < 6 ) {
                return 'Username too short' ;
                    } 
                  return null;
            },
           
            obscureText: _obscureText,
            decoration: InputDecoration(
                suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() => _obscureText = !_obscureText);
                    },
                    child: Icon(_obscureText
                        ? Icons.visibility
                        : Icons.visibility_off)),
                border: OutlineInputBorder(),
                labelText: 'Password',
                hintText: 'Enter password, min length 6',
                icon: Icon(Icons.lock, color: Colors.grey))));
  }

  Widget _showFormActions() {
    return Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Column(children: [
          _isSubmitting ? CircularProgressIndicator(valueColor:  AlwaysStoppedAnimation(Theme.of(context).accentColor)) : 
          RaisedButton(
              child: Text('Submit',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(color: Colors.black)),
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              color: Theme.of(context).accentColor,
              onPressed: _submit),
          FlatButton(
              child: Text('New user? Register'),
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/'))
        ]));
  }

  void _submit() {
    final form = _formKey.currentState;

    if (form!.validate()) {
      form.save();
      _registerUser();
    }
  }
  void _registerUser() async {
    setState(() => _isSubmitting = true);
    http.Response response = await http.post(
        Uri.parse('http://192.168.100.122:1337/auth/local'),
        body: {"identifier": _email, "password": _password});
    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() => _isSubmitting = false);
      _showSuccessSnack();
      _storeUserData(responseData);
      _redirectUser();
      print(responseData);
    } else {
      setState(() => _isSubmitting = false);
      final String errorMsg = responseData['message'].toString();
      _showErrorSnack(errorMsg);
    }
  }
  void _storeUserData(responseData) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> user = responseData['user'];
    user.putIfAbsent('jwt', () => responseData['jwt']);
    prefs.setString('user', json.encode(user));
  }

  void _showSuccessSnack() {
    final snackbar = SnackBar(
        content: Text('User successfully logged in!',
            style: TextStyle(color: Colors.green)));
    _scaffoldKey.currentState!.showSnackBar(snackbar);
    _formKey.currentState!.reset();
  }

  void _showErrorSnack(String errorMsg) {
    final snackbar =
        SnackBar(content: Text(errorMsg, style: TextStyle(color: Colors.red)));
    _scaffoldKey.currentState!.showSnackBar(snackbar);
    throw Exception('Error logging in: $errorMsg');
  }

  void _redirectUser() {
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, '/products');
    });
  }


  @override
  
  Widget build(BuildContext context) {
    
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    return Scaffold(
        appBar: AppBar(title: Text('Login')),
        key: _scaffoldKey,
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
                child: SingleChildScrollView(
                    child: Form(
                        key: _formKey,
                        child: SizedBox(
                          width: kIsWeb ? 600: 550  

                          , child: Column(children: [
                            _showTitle(),
                            _showEmailInput(),
                            _showPasswordInput(),
                            _showFormActions()
                          ]),
                        ))))));
  }
}