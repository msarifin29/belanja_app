import 'dart:convert';
import 'dart:async';
import 'package:belanja_app/common/handling_error.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _experyDate;
  String? _userId;
  Timer? _autoTimer;
  // Auth({required this.userId, required this.token, required this.experyDate});

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_token != null &&
        _experyDate != null &&
        _experyDate!.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId.toString();
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    //api key from web
    const apiKey = 'AIzaSyASwdp2KtFbBj1ROqAwiUTM7olci2N4j';
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$apiKey');
    try {
      final response = await http.post(url,
          body: jsonEncode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      final responseData = jsonDecode(response.body);
      if (responseData['error'] != null) {
        // check the response if an error occurs
        throw HttpException(responseData['error']['message']);
      }
      // default response from database Map<String, dynamic>
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _experyDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      autoLogout();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> sigup(String email, String password) async {
    //  return authenticate(email, password, 'signUpNewUser');
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    //  return authenticate(email, password, 'verifypassword');
    return _authenticate(email, password, 'signInWithPassword');
  }

  void logOut() {
    _token = null;
    _userId = null;
    _experyDate = null;
    if (_autoTimer != null) {
      _autoTimer!.cancel();
    }
    notifyListeners();
  }

  void autoLogout() {
    if (_autoTimer != null) {
      _autoTimer!.cancel();
    }
    final timerToExpiry = _experyDate!.difference(DateTime.now()).inSeconds;
    _autoTimer = Timer(Duration(seconds: timerToExpiry), logOut);
  }
}
