import 'package:flutter/foundation.dart';

import '../models/item.dart';
import '../models/order.dart';


class CartProvider with ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;
  int get itemCount => _cartItems.length;
  double get totalAmount => _cartItems.fold(0, (sum, item) => sum + item.total);

  void addItem(Item item) {
    final existingIndex = _cartItems.indexWhere((cartItem) => cartItem.itemId == item.id);

    if (existingIndex >= 0) {
      // Item already in cart, increment quantity
      _cartItems[existingIndex].quantity += 1;
    } else {
      // Add new item to cart
      _cartItems.add(
        CartItem(
          itemId: item.id,
          itemTitle: item.title,
          price: item.price,
          image: item.image,
          quantity: 1,
        ),
      );
    }

    notifyListeners();
  }

  void removeItem(int itemId) {
    _cartItems.removeWhere((item) => item.itemId == itemId);
    notifyListeners();
  }

  void decrementItem(int itemId) {
    final existingIndex = _cartItems.indexWhere((item) => item.itemId == itemId);

    if (existingIndex >= 0) {
      if (_cartItems[existingIndex].quantity > 1) {
        // Decrement quantity
        _cartItems[existingIndex].quantity -= 1;
      } else {
        // Remove item if quantity becomes zero
        _cartItems.removeAt(existingIndex);
      }

      notifyListeners();
    }
  }

  void incrementItem(int itemId) {
    final existingIndex = _cartItems.indexWhere((item) => item.itemId == itemId);

    if (existingIndex >= 0) {
      _cartItems[existingIndex].quantity += 1;
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems = [];
    notifyListeners();
  }

  bool isInCart(int itemId) {
    return _cartItems.any((item) => item.itemId == itemId);
  }
}