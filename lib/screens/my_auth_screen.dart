import 'dart:math';

import 'package:flutter/material.dart';

enum MyAuthMode {
  SignUp,
  Login,
}

class MyAuthScreen extends StatelessWidget {
  //const MyAppAuth({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
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
          SingleChildScrollView(
            child: Container(
              width: screenSize.width,
              height: screenSize.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(
                        bottom: 20,
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 94, vertical: 8),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        'MyShop',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Anton',
                          color: Theme.of(context).accentTextTheme.title.color,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: screenSize.width > 600 ? 2 : 1,
                    child: MyAuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyAuthCard extends StatefulWidget {
  const MyAuthCard({Key key}) : super(key: key);

  @override
  _MyAuthCardState createState() => _MyAuthCardState();
}

class _MyAuthCardState extends State<MyAuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _authMode = MyAuthMode.Login;
  var _isLoading = false;

  final _passwordController = TextEditingController();

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  void _submit() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    setState(() {
      _isLoading = true;
    });

    if (_authMode == MyAuthMode.Login) {
      //Log user in
    } else {
      //Signup user
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == MyAuthMode.Login) {
      setState(() {
        _authMode = MyAuthMode.SignUp;
      });
    } else {
      setState(() {
        _authMode = MyAuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == MyAuthMode.Login ? 260 : 320,
        constraints: BoxConstraints(
            minHeight: _authMode == MyAuthMode.Login ? 260 : 320),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid Email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please provide password';
                    }
                    if (value.length < 5) {
                      return 'Password too short!';
                    }

                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                if (_authMode == MyAuthMode.SignUp)
                  TextFormField(
                    enabled: _authMode == MyAuthMode.SignUp,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    validator: _authMode == MyAuthMode.SignUp
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'password do not match!';
                            }
                            return null;
                          }
                        : null,
                  ),
                SizedBox(
                  height: 20,
                ),
                _isLoading
                    ? CircularProgressIndicator()
                    : RaisedButton(
                        child: Text(
                            _authMode == MyAuthMode.Login ? 'LOGIN' : 'SIGNUP'),
                        onPressed: _submit,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 30.0,
                          vertical: 8.0,
                        ),
                        color: Theme.of(context).primaryColor,
                        textColor:
                            Theme.of(context).primaryTextTheme.button.color,
                      ),
                FlatButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                    '${_authMode == MyAuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD',
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 4.0),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
