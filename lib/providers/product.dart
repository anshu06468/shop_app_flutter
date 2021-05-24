import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import './../models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false,
  });

  Future<void> toggleFavouriteStatus() async {
    final url = Uri.parse(
        "https://flutter-app-f7636-default-rtdb.firebaseio.com/products/$id.json");
    bool existingStatus = isFavourite;
    try {
      isFavourite = !isFavourite;
      notifyListeners();
      await http.patch(
        url,
        body: json.encode({
          "isFavourite": isFavourite,
        }),
      );
    } catch (error) {
      isFavourite = existingStatus;
      notifyListeners();
      throw HttpException("Something went wrong");
    } finally {
      existingStatus = null;
    }
  }
}
