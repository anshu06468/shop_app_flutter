import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expireDate;
  String _userId;
  Timer _autologoutTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expireDate != null &&
        _token != null &&
        _expireDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> signUp(String email, String password) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAgdsZOi0XnHHl9-YB1A4HgdzSaCYZzOiE");
    try {
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      login(email, password);
      // print(json.decode(response.body));
    } catch (error) {
      // print(error.toString());
      throw error;
    }
  }

  Future<bool> tryautoLogin() async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey("userData")) return false;
    final extractedUserData =
        json.decode(pref.getString("userData")) as Map<String, Object>;
    final expirydate = DateTime.parse(extractedUserData["expirytime"]);
    if (expirydate.isBefore(DateTime.now())) return false;

    _token = extractedUserData["token"];
    _userId = extractedUserData["userId"];
    _expireDate = expirydate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> login(String email, String password) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAgdsZOi0XnHHl9-YB1A4HgdzSaCYZzOiE");
    try {
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData["idToken"];
      _userId = responseData["localId"];
      _expireDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData["expiresIn"])));
      // print(json.decode(response.body));
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userDate = json.encode({
        "userId": _userId,
        "token": _token,
        "expirytime": _expireDate.toIso8601String()
      });
      prefs.setString("userData", userDate);
    } catch (error) {
      // var res = json.decode(error);
      // print(res.toList());
      throw error;
    }
  }

  Future<void> logOut() async {
    _token = null;
    _userId = null;
    _expireDate = null;
    if (_autologoutTimer != null) {
      _autologoutTimer.cancel();
      _autologoutTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("userData"); //remove only userdata
    prefs.clear(); //remove everything from shared place
  }

  void _autoLogout() {
    if (_autologoutTimer != null) {
      _autologoutTimer.cancel();
    }
    final _expiryTime = _expireDate.difference(DateTime.now()).inSeconds;
    _autologoutTimer = Timer(Duration(seconds: _expiryTime), logOut);
  }
}
