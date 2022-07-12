import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem(
      {required this.id,
      required this.title,
      required this.price,
      required this.quantity});

  Map toJson() => {
        'id': id,
        'title': title,
        'quantity': quantity,
        'price': price,
      };
}

class Cart with ChangeNotifier {
  // ignore: prefer_final_fields
  Map<String, CartItem>? _items = {};

  Map<String, CartItem> get items {
    return {..._items!};
  }

  int get itemCount {
    return _items!.length;
  }

// total price X quantity item
  double get totalAmount {
    var total = 0.0;
    _items!.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

// adding item product to your cart
  void addItem(String productId, double price, String title) {
    if (_items!.containsKey(productId)) {
      _items?.update(
          productId,
          (existingCart) => CartItem(
              id: existingCart.id,
              title: existingCart.title,
              price: existingCart.price,
              quantity: existingCart.quantity + 1));
    } else {
      _items?.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1));
    }
    notifyListeners();
  }

// remove all product from your cart
  void removeItem(String productId) {
    _items!.remove(productId);
    notifyListeners();
  }

// remove single item product from your cart
  void removeSingleItem(String productId) {
    if (!_items!.containsKey(productId)) {
      return;
    }
    if (_items![productId]!.quantity > 1) {
      _items!.update(
          productId,
          (existingCart) => CartItem(
              id: existingCart.id,
              title: existingCart.title,
              price: existingCart.price,
              quantity: existingCart.quantity - 1));
    } else {
      _items!.remove(productId);
    }
    notifyListeners();
  }

// default if there is no order
  void clear() {
    _items = {};
    notifyListeners();
  }
}
