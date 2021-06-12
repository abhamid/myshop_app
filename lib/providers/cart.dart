import 'package:flutter/material.dart';

import '../model/cartitem.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalPrice {
    var total = 0.0;
    _items.forEach((key, item) {
      total += item.price * item.quantity;
    });

    return total;
  }

  bool isProductAdded(String productId) {
    return _items.containsKey(productId);
  }

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      //update the quantity of this cart item
      _items.update(
          productId,
          (oldItem) => CartItem(
                id: oldItem.id,
                title: oldItem.title,
                price: oldItem.price,
                quantity: oldItem.quantity + 1,
              ));
      notifyListeners();
    } else {
      //add this cartitem
      _items.putIfAbsent(
        productId,
        () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            price: price,
            quantity: 1),
      );
      notifyListeners();
    }
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeAnItem(String productId) {
    if (!_items.containsKey(productId)) return;

    var cartItem = _items[productId];

    if (cartItem.quantity <= 1) {
      _items.remove(productId);
      notifyListeners();
      return;
    }

    _items.update(
      productId,
      (oldItem) => CartItem(
          id: oldItem.id,
          title: oldItem.title,
          price: oldItem.price,
          quantity: oldItem.quantity - 1),
    );
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
