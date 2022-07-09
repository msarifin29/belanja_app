import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String? userId;
  String? token;
  DateTime? experyDate;
  // Auth({required this.userId, required this.token, required this.experyDate});

  Future<void> sigup(String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key= AIzaSyCZZmbaQOe6KIGikGRsMwLfwKu_nd1H-3o');
    final response = await http.post(url,
        body: jsonEncode({
          'email': email,
          'password': password,
          'returnScureToken': true.toString(),
        }));
    print(jsonDecode(response.body));
  }
}
