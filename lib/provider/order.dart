import 'dart:convert';

import 'package:belanja_app/provider/cart.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String? id;
  final double? amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
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

  final String? authToken;
  final String? userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    // input url here
    final url = Uri.parse(
      'https://belanja-bb72d-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json?=$authToken',
    );
    final timeStep = DateTime.now();

    try {
      // send data to Database
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

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
      'https://belanja-bb72d-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json?=$authToken',
    );
    try {
      // get data from Database
      final response = await http.get(url);
      // check response if null
      if (jsonDecode(response.body) == null) return;
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> loadedData = [];
      extractData.forEach((ordId, ordData) {
        loadedData.add(OrderItem(
            id: ordId,
            amount: ordData['amount'],
            dateTime: DateTime.parse(ordData['dateTime']),
            products: (ordData['products'] as List<dynamic>)
                .map((item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    price: item['price'],
                    quantity: item['quantity']))
                .toList()));
      });
      _orders = loadedData.reversed.toList();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
