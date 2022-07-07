import 'dart:convert';

import 'package:belanja_app/provider/cart.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String? id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {this.id,
      required this.amount,
      required this.products,
      required this.dateTime});

  Map toJson() => {
        'id': id!,
        'amount': amount,
        'products': products,
        'dateTime': dateTime.toIso8601String(),
      };
}

class Orders with ChangeNotifier {
  // ignore: prefer_final_fields
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    final url = Uri.parse(
      'https://belanja-app-1015a-default-rtdb.firebaseio.com/orders.json',
    );
    final timeStep = DateTime.now();

    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': timeStep.toIso8601String(),
            'products': cartProduct
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'quantity': cp.quantity,
                      'price': cp.price
                    })
                .toList()
          }));

      _orders.insert(
          0,
          OrderItem(
              id: json.decode(response.body)['name'],
              amount: total,
              products: cartProduct,
              dateTime: timeStep));
      notifyListeners();
    } catch (error) {
      throw UnsupportedError('Cannot conver to JSon');
    }
  }
}
