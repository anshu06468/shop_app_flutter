import 'package:flutter/material.dart';
import 'product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final authToken;
  final userId;
  Products(this.authToken, this._items, this.userId);

  List<Product> get items {
    // if (_showFavouritesOnly) {
    //   return _items.where((element) => element.isFavourite).toList();
    // } else
    return [..._items];
  }

  List<Product> get showFav {
    return _items.where((element) => element.isFavourite).toList();
  }
  //  this should not be used to show favourates data since it will affect everywhere in the app
  // to avoid this we should use local wise provider

  // void showFavouriteOnly() {
  //   _showFavouritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavouritesOnly = false;
  //   notifyListeners();
  // }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterBy = false]) async {
    final filterString =
        filterBy ? 'orderBy="creatorId"&equalTo="$userId"' : "";
    var url = Uri.parse(
        'https://flutter-app-f7636-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString');
    try {
      final response = await http.get(url);
      // print(json.decode(response.body));

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url = Uri.parse(
          "https://flutter-app-f7636-default-rtdb.firebaseio.com/userFavourates/$userId.json?auth=$authToken");
      final favouratesResponse = await http.get(url);
      final extractFav = json.decode(favouratesResponse.body);
      final List<Product> loadedData = [];
      extractedData.forEach((prodId, prodBody) {
        loadedData.add(Product(
          id: prodId,
          title: prodBody['title'],
          description: prodBody['description'],
          price: prodBody['price'],
          imageUrl: prodBody['imageUrl'],
          isFavourite: extractFav == null ? false : extractFav[prodId] ?? false,
        ));
      });

      _items = loadedData;
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> addProduct(Product product) {
    final url = Uri.parse(
        "https://flutter-app-f7636-default-rtdb.firebaseio.com/products.json?auth=$authToken");
    return http
        .post(
      url,
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'creatorId': userId,
      }),
    )
        .then((res) {
      final newProduct = Product(
          id: json.decode(res.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    }).catchError((error) {
      print(error.toString());
      throw error;
    });
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      var url = Uri.parse(
          "https://flutter-app-f7636-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken");
      try {
        await http.patch(url,
            body: json.encode({
              "title": newProduct.title,
              "description": newProduct.description,
              "price": newProduct.price,
              "imageUrl": newProduct.imageUrl,
            }));
        _items[prodIndex] = newProduct;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    } else {
      print("....");
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        "https://flutter-app-f7636-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken");
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    await http.delete(url).then((_) => existingProduct = null).catchError((e) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      existingProduct = null;
      throw e;
    });
  }
}
