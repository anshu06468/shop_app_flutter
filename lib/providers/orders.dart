import 'package:flutter/foundation.dart';
import 'package:shop/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _order = [];

  List<OrderItem> get item {
    return [..._order];
  }

  void addOrder(List<CartItem> cartproduct, double total) {
    _order.insert(
        0,
        OrderItem(
          id: DateTime.now().toString(),
          amount: total,
          products: cartproduct,
          dateTime: DateTime.now(),
        ));
    notifyListeners();
  }
}
