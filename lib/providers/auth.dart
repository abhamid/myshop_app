import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/http_exception.dart';

class Auth with ChangeNotifier {
  final _apiKey = 'AIzaSyDAbgU65siYp2zv-WGLeKmPG8Zo7GDfKDA';

  String _token;
  DateTime _expiry;
  String _userId;
  Timer _autoLogoutTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiry != null && DateTime.now().isBefore(_expiry) && _token != null) {
      return _token;
    }

    return null;
  }

  String get userId {
    return this._userId;
  }

  Future<void> _authenticate(String email, String password, String uri) async {
    final url = Uri.parse(uri);
    try {
      final response = await http.post(url,
          body: json.encode(
            {
              'email': email,
              'password': password,
              'returnSecureToken': true,
            },
          ));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(message: responseData['error']['message']);
      }
      //print(json.decode(response.body));
      this._token = responseData['idToken'];
      final strExpiresIn = responseData['expiresIn'];
      final intExpiresIn = int.parse(strExpiresIn);
      this._expiry = DateTime.now().add(Duration(seconds: intExpiresIn));
      this._userId = responseData['localId'];

      //print('Token: ${this._token}');
      //print('UserId: ${this._userId}');
      //print('Expiry: ${this._expiry}');

      _autoLogout();
      notifyListeners();

      //store the login data
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': this._token,
        'userId': this._userId,
        'expiry': this._expiry.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (error) {
      //print(error);
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    final uri =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${this._apiKey}';
    return this._authenticate(email, password, uri);
  }

  Future<void> signIn(String email, String password) async {
    final uri =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${this._apiKey}';
    return this._authenticate(email, password, uri);
  }

  Future<bool> tryAutoLogin() async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey('userData')) {
      return false;
    }

    String userData = pref.getString('userData');
    final userDataMap = json.decode(userData) as Map<String, Object>;
    final expiryDate = DateTime.parse(userDataMap['expiry']);

    if (expiryDate.isBefore(DateTime.now())) {
      pref.remove('userData');
      return false;
    }

    this._token = userDataMap['token'];
    this._userId = userDataMap['userId'];
    this._expiry = expiryDate;

    notifyListeners();
    _autoLogout();

    return true;
  }

  Future<void> logOut() async {
    this._token = null;
    this._expiry = null;
    this._userId = null;
    if (this._autoLogoutTimer != null) {
      _autoLogoutTimer.cancel();
      _autoLogoutTimer = null;
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');

    notifyListeners();
  }

  void _autoLogout() {
    if (_autoLogoutTimer != null) {
      _autoLogoutTimer.cancel();
      _autoLogoutTimer = null;
    }
    final timeToExpiry = this._expiry.difference(DateTime.now()).inSeconds;
    _autoLogoutTimer = Timer(Duration(seconds: timeToExpiry), logOut);
  }
}
