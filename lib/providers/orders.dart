import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/orderitem.dart';
import '../model/cartitem.dart';
import '../model/http_exception.dart';

class Orders with ChangeNotifier {
  final _authority = 'flutter-webapp-952d4-default-rtdb.firebaseio.com';

  var _authToken;
  var _userId;

  List<OrderItem> _items = [];

  List<OrderItem> get items {
    return [..._items];
  }

  void update(String authToken, String userId) {
    this._authToken = authToken;
    this._userId = userId;
  }

  Future<void> fetchOrdersFromServer() async {
    final url = Uri.parse(
        'https://${this._authority}/orders/${this._userId}.json?auth=${this._authToken}');

    try {
      final response = await http.get(url);
      //print(json.decode(response.body));
      List<OrderItem> fetchedOrderItems = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) return;
      extractedData.forEach((orderId, orderData) {
        final products = orderData['products'] as List<dynamic>;
        final orderItem = OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: products.map((cartItem) {
            return CartItem(
              id: cartItem['id'],
              title: cartItem['title'],
              price: cartItem['price'],
              quantity: cartItem['quantity'],
            );
          }).toList(),
        );

        fetchedOrderItems.add(orderItem);
      });

      _items = fetchedOrderItems.reversed.toList();
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> addOrder(List<CartItem> products, double totalAmount) async {
    final url = Uri.parse(
        'https://${this._authority}/orders/${this._userId}.json?auth=${this._authToken}');

    try {
      var timeStamp = DateTime.now();

      final response = await http.post(
        url,
        body: json.encode({
          'amount': totalAmount,
          'dateTime': timeStamp.toIso8601String(),
          'products': products
              .map((cartItem) => {
                    'id': cartItem.id,
                    'title': cartItem.title,
                    'price': cartItem.price,
                    'quantity': cartItem.quantity,
                  })
              .toList(),
        }),
      );

      var orderId = json.decode(response.body)['name'];
      var orderItem = OrderItem(
        id: orderId,
        amount: totalAmount,
        products: [...products],
        dateTime: timeStamp,
      );

      _items.insert(0, orderItem);

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
