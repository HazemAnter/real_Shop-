import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:real_shop/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem extends ChangeNotifier {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders extends ChangeNotifier {
  List<OrderItem> _orders = [];

  String? authToken;
  String? userId;

  getData(String? authtoken, String? uId, List<OrderItem> orders) {
    authToken = authtoken;
    userId = uId;
    _orders = orders;
    notifyListeners();
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetProducts() async {
    Uri url = Uri.parse(
        'https://shopapp-bf8f0-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    try {
      final res = await http.get(url);
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      List<OrderItem> loadedOrders = [];
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price']))
              .toList(),
        ));
        _orders = loadedOrders.reversed.toList();
        notifyListeners();
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> addOrder(List<CartItem> carProduct, double total) async {
    Uri url = Uri.parse(
        'https://shopapp-bf8f0-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');

    try {
      final timeStamp = DateTime.now();
      final res = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': timeStamp.toIso8601String(),
            'products': carProduct
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'quantity': cp.quantity,
                      'price': cp.price
                    })
                .toList(),
          }));
      _orders.insert(
          0,
          OrderItem(
            id: json.decode(res.body)['name'],
            amount: total,
            dateTime: timeStamp,
            products: carProduct,
          ));
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
