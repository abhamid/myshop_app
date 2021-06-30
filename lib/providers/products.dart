import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';
import '../model/http_exception.dart';

class Products with ChangeNotifier {
  final _authority = 'flutter-webapp-952d4-default-rtdb.firebaseio.com';

  var _authToken;
  var _userId;

  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((item) => item.isFavourite).toList();
  }

  void update(String authToken, String userid) {
    this._authToken = authToken;
    this._userId = userid;
  }

  Product findById(String id) {
    return items.firstWhere((item) => item.id == id);
  }

  Future<void> fetchProductsFromServer([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? '&orderBy="creatorId"&equalTo="${this._userId}"' : '';
    var url = Uri.parse(
        'https://${this._authority}/products.json?auth=${this._authToken}${filterString}');
    try {
      final response = await http.get(url);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      //print(json.decode(response.body));
      url = Uri.parse(
          'https://${this._authority}/userfavorites/${this._userId}.json?auth=${this._authToken}');
      final responseFavourites = await http.get(url);

      final userFavouritesData = json.decode(responseFavourites.body);

      final List<Product> fetchedProducts = [];
      extractedData.forEach((prodId, prodData) {
        fetchedProducts.insert(
            0,
            Product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              price: prodData['price'],
              imageUrl: prodData['imageUrl'],
              isFavourite: userFavouritesData == null
                  ? false
                  : userFavouritesData[prodId] ?? false,
            ));
      });
      this._items = fetchedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addProductAsync(
    String title,
    String description,
    double price,
    String imageUrl,
  ) async {
    //final url = Uri.https(_authority, '/products.json?auth=${this._authToken}');
    final url = Uri.parse(
        'https://${this._authority}/products.json?auth=${this._authToken}');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': title,
          'description': description,
          'price': price,
          'imageUrl': imageUrl,
          'creatorId': this._userId,
        }),
      );

      var productId = json.decode(response.body)['name'];
      var productToAdd = Product(
        id: productId,
        title: title,
        description: description,
        imageUrl: imageUrl,
        price: price,
      );

      _items.add(productToAdd);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addProduct(
    String title,
    String description,
    double price,
    String imageUrl,
  ) {
    //final url = Uri.https(_authority, '/products.json?auth=${this._authToken}');
    final url = Uri.parse(
        'https://${this._authority}/products.json?auth=${this._authToken}');
    return http
        .post(
      url,
      body: json.encode({
        "title": title,
        "description": description,
        "price": price,
        "imageUrl": imageUrl,
        "creatorId": this._userId,
      }),
    )
        .then((response) {
      final product = Product(
        id: json.decode(response.body)["name"],
        title: title,
        description: description,
        price: price,
        imageUrl: imageUrl,
      );

      _items.add(product);
      notifyListeners();
    }).catchError((error) {
      print(error);
      throw error;
    });
  }

  Future<void> editProductAsync(Product productToEdit) async {
    if (productToEdit == null || productToEdit.id == null) return;
    //final url = Uri.https(_authority, '/products/${productToEdit.id}.json');
    final url = Uri.parse(
        'https://${this._authority}/products/${productToEdit.id}.json?auth=${this._authToken}');
    try {
      final response = await http.patch(
        url,
        body: json.encode({
          'title': productToEdit.title,
          'description': productToEdit.description,
          'price': productToEdit.price,
          'imageUrl': productToEdit.imageUrl,
        }),
      );

      //print('${json.decode(response.body)}');

      int productIndex = -1;
      if (productToEdit.id != null) {
        productIndex =
            _items.indexWhere((product) => product.id == productToEdit.id);
      }
      _items[productIndex] = productToEdit;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void editProduct(Product productToEdit) {
    if (productToEdit == null) return;

    String editProductId = productToEdit.id;
    int productIndex = -1;
    if (productToEdit.id != null) {
      productIndex =
          _items.indexWhere((product) => product.id == editProductId);
    }

    if (productIndex < 0) {
      addProduct(
        productToEdit.title,
        productToEdit.description,
        productToEdit.price,
        productToEdit.imageUrl,
      );
    } else {
      _items[productIndex] = productToEdit;
      notifyListeners();
    }
  }

  Future<void> deleteProductAsync(String productId) async {
    if (productId == null) return;
    //final url = Uri.https(_authority, '/products/$productId.json');
    final url = Uri.parse(
        'https://${this._authority}/products/$productId.json?auth=${this._authToken}');

    final productIndex =
        _items.indexWhere((product) => product.id == productId);
    var productToRemove = _items[productIndex];

    _items.removeAt(productIndex);
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(productIndex, productToRemove);
      notifyListeners();
      throw HttpException(message: 'Error occured while delete');
    }

    productToRemove = null;
  }

  void deleteProduct(String productId) {
    if (productId == null) return;
    //final url = Uri.https(_authority, '/products/$productId.json');

    final url = Uri.parse(
        'https://${this._authority}/products/$productId.json?auth=${this._authToken}');

    final productIndex =
        _items.indexWhere((product) => product.id == productId);
    var productToRemove = _items[productIndex];
    _items.remove(productIndex);
    //_items.removeWhere((product) => product.id == productId);
    http.delete(url).then((response) {
      print(response.statusCode);
      if (response.statusCode >= 400) {
        throw HttpException(message: 'Error occured while delete');
      }
      productToRemove = null;
      notifyListeners();
    }).catchError((error) {
      print(error);
      _items.insert(productIndex, productToRemove);
    });
  }
}
