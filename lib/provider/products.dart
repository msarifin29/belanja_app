import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './product.dart';

class Products with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

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
      'https://belanja-bb72d-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?=$authToken',
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
            'creatorId': userId
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
        'https://belanja-bb72d-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?=$authToken&$filterString');
    try {
      final response = await http.get(url);
      if (jsonDecode(response.body) == null) return;
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      var urlFav = Uri.parse(
          'https://belanja-bb72d-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId.json?=$authToken');
      var favoriteResponse = await http.get(urlFav);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedData = [];
      extractedData.forEach((prodId, prodData) {
        loadedData.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            isFavorite:
                favoriteData == null ? false : favoriteData[prodId] ?? false,
            price: prodData['price'],
            imageUrl: prodData['imageUrl']));
      });
      _items = loadedData;
      notifyListeners();
    } catch (error) {
      // ignore: use_rethrow_when_possible
      throw error;
    }
  }

// update data product via PATCH request
  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      final url = Uri.parse(
          'https://belanja-bb72d-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?=$authToken');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl
          }));
      _items[productIndex] = newProduct;
      notifyListeners();
    } else {
      print('....');
    }
  }

//delete product
  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
      'https://belanja-bb72d-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?=$authToken',
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
