import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _obscureText = true;
  String _username='', _email='', _password='';
  bool _isSubmitting = false;

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
        Uri.parse('http://192.168.100.122:1337/auth/local/register'),
        body: {"username": _username, "email": _email, "password": _password});
    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() => _isSubmitting = false);
      _showSuccessSnack();
      _storeUserData(responseData);
      _redirectUser();
      print(responseData);
    } else {
      setState(() => _isSubmitting = false);
      String errorMessage;
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

   void _redirectUser() {
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, '/products');
    });
  }
  
// for error
 void _showErrorSnack(String errorMsg) {
  
    final snackbar =
        SnackBar(content: Text(errorMsg, style: TextStyle(color: Colors.red)));
    _scaffoldKey.currentState!.showSnackBar(snackbar);
    throw Exception('Error registering: $errorMsg');
  }
  void _showErrorDialog(String message) { // for displaying any error 
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            title: Text('An Error Occurred!'),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
    );
  }

   void _showSuccessSnack() {
    final snackbar = SnackBar(
        content: Text('User $_username successfully created!',
            style: TextStyle(color: Colors.green)));
    _scaffoldKey.currentState!.showSnackBar(snackbar);
    _formKey.currentState!.reset();
  }


  Widget _showTitle() {
    return Text('Register', style: Theme.of(context).textTheme.headline1);
  }

  Widget _showUsernameInput() {
    return Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: TextFormField(
            onSaved: (value) => _username = value!,
            validator: (value) {
                    if (value!.isEmpty || value.length < 6) {
                      return 'userName must be 6 digits long';
                    }
                     return null;
                  },
            
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
                hintText: 'Enter username, min length 6',
                icon: Icon(Icons.face, color: Colors.grey))));
  }

  Widget _showEmailInput() {
    return Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: TextFormField(
            onSaved: (val) { _email = val!; },
            validator: (values) {if (values!.isEmpty || !values.contains('@')) {
                      return 'Invalid Email';
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
            validator: (val)  {
              if (val!.isEmpty || val.length < 6 ) {
                return 'password should be 6 digits long ';
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

          _isSubmitting ? CircularProgressIndicator(valueColor:  AlwaysStoppedAnimation(Theme.of(context).primaryColor)) : 
          RaisedButton(
              child: Text('Submit',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(color: Colors.black)),
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              color: Theme.of(context).primaryColor,
              onPressed: _submit
              ),
          FlatButton(
              child: Text('Existing user? Login'),
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/'))
        ]));
  }

 

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    return Scaffold(
      key:_scaffoldKey,
        appBar: AppBar(title: Text('Register')),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
                child: SingleChildScrollView(
                    child: Form(
                        key: _formKey,
                        child: SizedBox(
                          width: kIsWeb ? 600: 550  
                          ,child: Column(children: [
                            _showTitle(),
                            _showUsernameInput(),
                            _showEmailInput(),
                            _showPasswordInput(),
                            _showFormActions()
                          ]),
                        ))))));
  }
}
