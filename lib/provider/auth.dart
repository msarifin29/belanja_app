import 'dart:convert';
import 'package:belanja_app/common/handling_error.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String? _token;
  DateTime? experyDate;
  String? _userId;
  // Auth({required this.userId, required this.token, required this.experyDate});

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_token != '' && experyDate != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId!;
  }

  Future<void> authenticate(
      String email, String password, String urlSegment) async {
    const apiKey = 'AIzaSyCZZmbaQOe6KIGikGRsMwLfwKu_nd1H-3o';
    try {
      final url = Uri.parse(
          'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$apiKey');
      final response = await http.post(url,
          body: jsonEncode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      final responseData = jsonDecode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> sigup(String email, String password) async {
    //  return authenticate(email, password, 'signUpNewUser');
    return authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    //  return authenticate(email, password, 'verifypassword');
    return authenticate(email, password, 'signInWithPassword');
  }
}
