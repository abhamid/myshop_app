import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../model/http_exception.dart';

class Auth with ChangeNotifier {
  final _apiKey = 'AIzaSyDAbgU65siYp2zv-WGLeKmPG8Zo7GDfKDA';

  String _token;
  DateTime _expiry;
  String _userId;

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

      notifyListeners();
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

  void logOut() {
    this._token = null;
    this._expiry = null;
    this._userId = null;

    notifyListeners();
  }
}
