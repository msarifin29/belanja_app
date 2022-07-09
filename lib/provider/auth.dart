import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String? userId;
  String? token;
  DateTime? experyDate;
  // Auth({required this.userId, required this.token, required this.experyDate});

  Future<void> authenticate(
      String email, String password, String urlSegment) async {
    const apiKey = 'AIzaSyCZZmbaQOe6KIGikGRsMwLfwKu_nd1H-3o';
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$apiKey');
    final response = await http.post(url,
        body: jsonEncode({
          'email': email,
          'password': password,
          'returnScureToken': true.toString(),
        }));
    print(jsonDecode(response.body));
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
