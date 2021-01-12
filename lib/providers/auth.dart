import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth extends ChangeNotifier {
  static const routeName = '/Auth';

  String _userId;
  DateTime _expiryDate;
  String _token;
  Timer _authTimer;
  // Similarly here also we have a url for signin and signup and we can use post
  // method to get authtiacte u=our credentials
  // Below is the official docs
  // https://firebase.google.com/docs/reference/rest/auth#section-create-email-password
  // while authnticating thorugh email, body of post method require email,password,returnSecureToken field
  Future<void> authenticate(String email, String password, String urlId) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlId?key=AIzaSyDzeowzktafcZw46ho6qLKueknpKRqN9ns';

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      print(json.decode(response.body));
      if (responseData['error'] != null) // Uf the body contain an error key
        throw HttpException(responseData['error']['message']);
      _userId = responseData['localId'];
      _token = responseData['idToken'];
      // responseData['expiresIn'] is in seconds upto which the token will exist
      // and we have added that time to our current time to get expiry date
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      // after login, session will automatically expire after some time
      _autoLogout();
      notifyListeners();
      // Here we are storing details in the device itself
      final sprefs = await SharedPreferences.getInstance();
      // we can only store some selected data type which you can exprore using
      // dot operator in fornt of object of SharedPreferences
      // One Data type is String and to store complex data type like map
      // we first encode it to json and json is a String
      // then add it to object of SharedPreferences
      // It takes to pareameter, 1st one the key and 2nd is the Value
      // We can only access item through this key
      final authData = json.encode({
        'userId': _userId,
        'token': _token,
        'expiryDate': _expiryDate.toIso8601String()
      });
      sprefs.setString('authData', authData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return authenticate(
        email, password, 'signUp'); // return reason need more understanding
  }

  Future<void> signin(String email, String password) async {
    return authenticate(email, password, 'signInWithPassword');
  }

  bool get isAuth {
    return getToken != null;
  }

  String get getToken {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) return _token;
    return null;
  }

  String get getUserId {
    return _userId;
  }

  Future<void> logout() async {
    _userId = null;
    _token = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    final sprefs = await SharedPreferences.getInstance();
    sprefs.remove('authData'); // this will remove data with the provided key
    // sprefs.clear(); // this will remove all the data
    // since in our case we have only one data so, both can be used
    notifyListeners();
  }

  // Here we set a Timer which is there in the async package in dart
  // In order to execute this method we have to call in on the place where
  // we have lagged in so that our timer can be set
  // Timer() takes to paramter as argument
  // 1st is Duration and 2nd is the function that would exexute after this Timer
  void _autoLogout() {
    // In case we have an active timer then we will close that timer and assign
    // to our timer.
    if (_authTimer != null) _authTimer.cancel();
    final timeToLogout = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToLogout), logout);
  }

  // This function will return Future<bool> depending upon weather we have
  // existing valid token
  // Here we are checking data which is stored in the device so, first we have
  // stored data when even a user loggined in the authenticate() method
  Future<bool> tryAutoLogin() async {
    final sprefs = await SharedPreferences.getInstance();
    // First check wheater it actually contain key:- authData
    if (!sprefs.containsKey('authData')) return false;
    // If yes, then w'll check the expiry data
    final extractedUserData =
        json.decode(sprefs.getString('authData')) as Map<String, Object>;
    final extractedExpiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (extractedExpiryDate.isBefore(DateTime.now())) return false;
    // if curr time is before expiry date then simply update our variables
    _expiryDate = extractedExpiryDate;
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    notifyListeners();
    _autoLogout();
    return true;
  }
}
