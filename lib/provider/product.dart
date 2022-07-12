import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String? id;
  final String? title;
  final String? description;
  final String? imageUrl;
  final double? price;
  bool? isFavorite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.imageUrl,
      required this.price,
      this.isFavorite = false});

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
  }

  Future<void> toggleFavoriteStatus(String? token) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite!;
    notifyListeners();
    final url = Uri.parse(
      'https://belanja-app-1015a-default-rtdb.firebaseio.com/products/$id.json?=$token',
    );
    try {
      final response =
          await http.patch(url, body: json.encode({'isFavorite': isFavorite}));
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus!);
      }
    } catch (error) {
      _setFavValue(oldStatus!);
    }
  }
}
