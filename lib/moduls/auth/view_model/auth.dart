import 'dart:convert';
import 'dart:async';
import 'package:belanja_app/helpers/handling_error.dart';
import 'package:belanja_app/utils/constant/end_point.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expireDate;
  String? _userId;
  Timer? _autoTimer;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_token != null &&
        _expireDate != null &&
        _expireDate!.isAfter(
          DateTime.now(),
        )) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId.toString();
  }

  Future<void> _authenticate(
    String email,
    String password,
    Uri url,
  ) async {
    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      final responseData = jsonDecode(response.body);
      if (responseData['error'] != null) {
        // check the response if an error occurs
        throw HttpException(responseData['error']['message']);
      }
      // default response from database Map<String, dynamic>
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expireDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = jsonEncode({
        'token': _token,
        'userId': _userId,
        'expireDate': _expireDate!.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> sigup(String email, String password) async {
    final url = Uri.parse(EndPoint.signUp);
    return _authenticate(email, password, url);
  }

  Future<void> login(String email, String password) async {
    final url = Uri.parse(EndPoint.logIn);
    return _authenticate(email, password, url);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = jsonDecode(prefs.getString('userData').toString())
        as Map<String, dynamic>;
    final expireDate =
        DateTime.parse(extractedUserData['expireDate'].toString());
    if (expireDate.isBefore(
      DateTime.now(),
    )) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expireDate = expireDate;

    notifyListeners();
    autoLogout();
    return true;
  }

  Future<void> logOut() async {
    _token = null;
    _userId = null;
    _expireDate = null;
    if (_autoTimer != null) {
      _autoTimer!.cancel();
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void autoLogout() {
    if (_autoTimer != null) {
      _autoTimer!.cancel();
    }
    final timerToExpiry = _expireDate!.difference(DateTime.now()).inSeconds;
    _autoTimer = Timer(Duration(seconds: timerToExpiry), logOut);
  }
}
