import 'dart:convert';
import 'dart:io';

import 'package:belanja_app/utils/constant/end_point.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'product.dart';

class Products with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Product> _items = [];

  final String? authToken;
  final String? userId;

  Products(this.authToken, this._items, this.userId);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite!).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

// add new product and sending post request
  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
      '$EndPoint.firebaseDatabase/products.json?=$authToken',
    );
    try {
      final res = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId,
          },
        ),
      );
      final newProduct = Product(
          id: json.decode(res.body)['name'],
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price);
      _items.add(newProduct);
      //_items.inssert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

// fetching data product
  Future<void> fetchAndSetProducts([filterByUser = false]) async {
    var filterString =
        filterByUser ? "orderBy=\"creatorId\"&equalTo=\"$userId\"" : "";
    final url = Uri.parse(
        '${EndPoint.firebaseDatabase}/products.json?=$authToken&$filterString');
    try {
      final response = await http.get(url);
      if (jsonDecode(response.body) == null) return;
      if (kDebugMode) {
        print(response.body);
      }
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      var urlFav = Uri.parse(
          '${EndPoint.firebaseDatabase}/userFavorites/$userId.json?=$authToken');
      var favoriteResponse = await http.get(urlFav);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedData = [];
      extractedData.forEach((prodId, prodData) {
        loadedData.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            isFavorite:
                favoriteData == null ? false : favoriteData[prodId] ?? false,
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
          ),
        );
      });
      _items = loadedData;
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
      // ignore: use_rethrow_when_possible
      throw error;
    }
  }

// update data product via PATCH request
  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      final url = Uri.parse(
          '${EndPoint.firebaseDatabase}/products/$id.json?=$authToken');
      await http.patch(
        url,
        body: json.encode(
          {
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          },
        ),
      );
      _items[productIndex] = newProduct;
      notifyListeners();
    } else {}
  }

//delete product
  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
      '${EndPoint.firebaseDatabase}/products/$id.json?=$authToken',
    );
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw const HttpException('Could not delete product. ');
    }
    existingProduct = null;
  }
}
