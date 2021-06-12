import 'package:flutter/material.dart';

import '../model/orderitem.dart';
import '../model/cartitem.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _items = [];

  List<OrderItem> get items {
    return [..._items];
  }

  void addOrder(List<CartItem> products, double totalAmount) {
    var orderItem = OrderItem(
      id: DateTime.now().toString(),
      amount: totalAmount,
      products: [...products],
      dateTime: DateTime.now(),
    );

    _items.insert(0, orderItem);
    notifyListeners();
  }
}
