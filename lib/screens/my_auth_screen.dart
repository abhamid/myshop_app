import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../model/http_exception.dart';

enum MyAuthMode {
  SignUp,
  Login,
}

class MyAuthScreen extends StatelessWidget {
  const MyAuthScreen({Key key}) : super(key: key);

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

class _MyAuthCardState extends State<MyAuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _authMode = MyAuthMode.Login;
  var _isLoading = false;

  final _passwordController = TextEditingController();

  AnimationController _animationController;
  Animation<double> _opacityAnimation;
  Animation<Offset> _slideAnimation;

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0.0, -1.5),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));

    //Commented out as this way of animation is not good as it re-rended
    //the entire widget
    // _heightAnimation.addListener(() {
    //   setState(() {});
    // });
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _animationController.dispose();
  }

  void showErrorDialog(String errorMessage) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errorMessage),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Okay'),
              ),
            ],
          );
        });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == MyAuthMode.Login) {
        //Log user in
        await Provider.of<Auth>(context, listen: false)
            .signIn(_authData['email'], _authData['password']);
      } else {
        //Signup user
        await Provider.of<Auth>(context, listen: false).signUp(
          _authData['email'],
          _authData['password'],
        );
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';

      if (error.message.contains('EMAIL_EXISTS')) {
        errorMessage = 'Email Exists';
      } else if (error.message.contains('OPERATION_NOT_ALLOWED')) {
        errorMessage = 'Operation Not allowed';
      } else if (error.message.contains('TOO_MANY_ATTEMPTS_TRY_LATER')) {
        errorMessage = 'Too many attempts try later';
      } else if (error.message.contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password';
      } else if (error.message.contains('USER_DISABLED')) {
        errorMessage = 'This user has been disabled';
      }

      showErrorDialog(errorMessage);
    } catch (error) {
      var errorMessage = 'Could not authenticate! Please try again later.';
      showErrorDialog(errorMessage);
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
      _animationController.forward();
    } else {
      setState(() {
        _authMode = MyAuthMode.Login;
      });
      _animationController.reverse();
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
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _authMode == MyAuthMode.Login ? 260 : 320,
        //height: _heightAnimation.value.height,
        constraints: BoxConstraints(
            minHeight: _authMode == MyAuthMode.Login ? 260 : 320),
        //minHeight: _heightAnimation.value.height,
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
                //if (_authMode == MyAuthMode.SignUp)
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  constraints: BoxConstraints(
                    minHeight: _authMode == MyAuthMode.SignUp ? 60 : 0,
                    maxHeight: _authMode == MyAuthMode.SignUp ? 120 : 0,
                  ),
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: TextFormField(
                        enabled: _authMode == MyAuthMode.SignUp,
                        decoration:
                            InputDecoration(labelText: 'Confirm Password'),
                        validator: _authMode == MyAuthMode.SignUp
                            ? (value) {
                                if (value != _passwordController.text) {
                                  return 'password do not match!';
                                }
                                return null;
                              }
                            : null,
                      ),
                    ),
                  ),
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
