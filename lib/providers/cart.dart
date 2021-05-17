import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String imgSrc;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
    @required this.imgSrc,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.price;
    });
    return total;
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void addItem(
    String productId,
    double price,
    String title,
    String imgSrc,
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingItem) => CartItem(
                id: existingItem.id,
                title: existingItem.title,
                quantity: existingItem.quantity + 1,
                price: existingItem.price,
                imgSrc: existingItem.imgSrc,
              ));
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
            id: DateTime.now().toString(),
            price: price,
            title: title,
            quantity: 1,
            imgSrc: imgSrc),
      );
      notifyListeners();
    }
  }
}
