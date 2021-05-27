import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
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
  final String authToken;
  final String userId;

  List<OrderItem> _order = [];

  Orders(this.authToken, this._order, this.userId);

  List<OrderItem> get order {
    return [..._order];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        "https://flutter-app-f7636-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken");
    try {
      final response = await http.get(url);
      final extractedOrders = json.decode(response.body);
      List<OrderItem> loadedOrders = [];
      if (extractedOrders == null) {
        return;
      }

      extractedOrders.forEach((orderId, orderD) {
        loadedOrders.add(
          OrderItem(
            id: orderId,
            amount: orderD["amount"],
            dateTime: DateTime.parse(orderD["datetime"]),
            products: (orderD["products"] as List<dynamic>)
                .map((item) => CartItem(
                      id: item['id'],
                      imgSrc: item["imgSrc"],
                      price: item["price"],
                      quantity: item["quantity"],
                      title: item["title"],
                    ))
                .toList(),
          ),
        );
      });
      _order = loadedOrders;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(List<CartItem> cartproduct, double total) async {
    final timestamp = DateTime.now();
    try {
      final url = Uri.parse(
          "https://flutter-app-f7636-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken");
      final response = await http.post(url,
          body: json.encode({
            "amount": total,
            "datetime": timestamp.toIso8601String(),
            "products": cartproduct
                .map((item) => {
                      "id": item.id,
                      "title": item.title,
                      "quantity": item.quantity,
                      "price": item.price,
                      "imgSrc": item.imgSrc,
                    })
                .toList()
          }));
      _order.insert(
          0,
          OrderItem(
            id: json.decode(response.body)["name"],
            amount: total,
            products: cartproduct,
            dateTime: timestamp,
          ));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
