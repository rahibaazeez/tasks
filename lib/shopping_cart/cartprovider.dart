// cart_provider.dart
import 'package:flutter/material.dart';

import 'cartmodelclass.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  double get totalCost {
    return _cartItems.fold(0, (sum, item) => sum + item.price);
  }

  void addToCart(CartItem item) {
    _cartItems.add(item);
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _cartItems.remove(item);
    notifyListeners();
  }
}
