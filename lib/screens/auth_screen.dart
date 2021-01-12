import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/http_exception.dart';

import '../providers/auth.dart';

enum AuthMode { SignUp, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/Auth-Screen';
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop App'),
      ),
      body: Stack(
        children: [
          Container(
            // height: deviceSize.height,
            // width: deviceSize.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          // SingleChildScrollView(
          Container(
            height: deviceSize.height,
            width: deviceSize.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 94),
                    transform: Matrix4.rotationZ(-8 * pi / 180)
                      ..translate(
                          -10.0), // double dot operator helps us to return parent type object
                    // for eg. here translate does not return any thing but
                    // transform field requires a Matrix4 object whict is returned
                    // by it's parent method ratationZ()
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.deepOrange.shade900,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8,
                          color: Colors.black26,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: Text(
                      'MyShop',
                      style: TextStyle(
                        fontSize: 50,
                        fontFamily: 'Anton',
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).accentTextTheme.title.color,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: AuthCard(),
                ),
              ],
            ),
          ),
          // )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final _form = GlobalKey<FormState>();
  var _authMode = AuthMode.Login;
  bool _isLoading = false;
  final passwordController = TextEditingController();
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  void _toggleMode() {
    setState(() {
      if (_authMode == AuthMode.Login)
        _authMode = AuthMode.SignUp;
      else
        _authMode = AuthMode.Login;
    });
  }

  void showErrorDialogBox(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('An Error Occured!!'),
        content: Text(message),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Okay'),
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final isValid = _form.currentState.validate();
    if (!isValid) return;
    setState(() {
      _isLoading = true;
    });
    _form.currentState.save();
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false)
            .signin(_authData['email'], _authData['password']);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signup(_authData['email'], _authData['password']);
      }
    } on HttpException catch (error) {
      // on <Exception> is used to handle specific exception
      String errorMess = 'Authentication Failed!!';
      if (error.toString().contains('EMAIL_EXISTS'))
        errorMess = 'Email Address already exist';
      else if (error.toString().contains('INVALID_EMAIL'))
        errorMess = 'Email Address is invalid';
      else if (error.toString().contains('WEAK_PASSWORD'))
        errorMess = 'Password is too weak';
      else if (error.toString().contains('EMAIL_NOT_FOUND'))
        errorMess = 'Email does not exist';
      else if (error.toString().contains('INVALID_PASSWORD'))
        errorMess = 'Invalid Password';
      showErrorDialogBox(errorMess); // to show dialog box
    } catch (error) {
      const String errorMess =
          'Could not authenticate you. Please try again later';
      showErrorDialogBox(errorMess);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8,
      child: Container(
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.SignUp ? 450 : 300),
        height: _authMode == AuthMode.SignUp ? 420 : 260,
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Email Id'),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onSaved: (newEmail) {
                  _authData['email'] = newEmail;
                },
                validator: (newEmail) {
                  // print(deviceSize.width);
                  // print(deviceSize.height);
                  if (newEmail.isEmpty || newEmail.contains('@') == false)
                    return 'Invalid Email';
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                controller: passwordController,
                textInputAction: _authMode == AuthMode.SignUp
                    ? TextInputAction.next
                    : TextInputAction.done,
                keyboardType: TextInputType.text,
                onSaved: (newPass) {
                  _authData['password'] = newPass;
                },
                validator: (newPass) {
                  if (newPass.isEmpty || newPass.length < 6)
                    return 'Invalid Password';
                },
              ),
              if (_authMode == AuthMode.SignUp)
                TextFormField(
                  decoration: InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: _authMode == AuthMode.SignUp
                      ? (newConfirmPass) {
                          if (newConfirmPass != passwordController.text)
                            return 'Passowrd does not match';
                        }
                      : null,
                ),
              SizedBox(
                height: 20,
              ),
              if (_isLoading)
                Container(
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    _authMode == AuthMode.SignUp ? 'SignUp' : 'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: _submit,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              FlatButton(
                child: Text(
                  '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onPressed: _toggleMode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
