import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:real_shop/models/http_exception.dart';
import './product.dart';
import 'package:http/http.dart' as http;

class Products extends ChangeNotifier {
  List<Product> _items = [];

  String? authToken;
  String? userId;

  getData(String? authTok, String? uId, List<Product> items) {
    authToken = authTok;
    userId = uId;
    _items = items;
    notifyListeners();
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((proItem) => proItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts({bool filterByUser = false}) async {
    final filteredString =
        filterByUser ? 'orderBy="creatorId"&equalTo"$userId"' : '';
    Uri url = Uri.parse(
        'https://shopapp-bf8f0-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filteredString');
    try {
      final res = await http.get(url);
      final extractedData = json.decode(res.body);
      if (extractedData == null) {
        return;
      }
      url = Uri.parse(
          'https://shopapp-bf8f0-default-rtdb.firebaseio.com/userFavorites.json?auth=$authToken');
      final favRes = await http.get(url);
      final favData = json.decode(favRes.body);
      List<Product> loadedProducts = [];
      extractedData.forEach((proId, proData) {
        loadedProducts.add(Product(
          id: proId,
          title: proData['title'],
          description: proData['description'],
          imageUrl: proData['imageUrl'],
          price: proData['price'],
          isFavorite: proData[proId] ?? false,
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addProduct(Product product) async {
    Uri url = Uri.parse(
        'https://shopapp-bf8f0-default-rtdb.firebaseio.com/products.json?auth=$authToken');

    try {
      final res = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId,
          }));
      final newProduct = Product(
          id: json.decode(res.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    Uri url = Uri.parse(
        'https://shopapp-bf8f0-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');

    final prodIndex = _items.indexWhere((prod) => prod.id == id);

    if (prodIndex >= 0) {
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl
          }));
      _items[prodIndex] = newProduct;
    } else {
      print(".....");
    }
  }

  Future<void> deleteProduct(String id) async {
    Uri url = Uri.parse(
        'https://shopapp-bf8f0-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    var existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final res = await http.delete(url);
    if (res.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('could not delete product');
    }
    existingProduct = null;
  }
}
