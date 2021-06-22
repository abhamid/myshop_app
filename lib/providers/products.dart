import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';
import '../model/http_exception.dart';

class Products with ChangeNotifier {
  final _authority = 'flutter-webapp-952d4-default-rtdb.firebaseio.com';
  final _productsEndPoint = '/products.json';

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

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((item) => item.isFavourite).toList();
  }

  Product findById(String id) {
    return items.firstWhere((item) => item.id == id);
  }

  Future<void> fetchProductsFromServer() async {
    final url = Uri.https(_authority, _productsEndPoint);
    try {
      final response = await http.get(url);
      final List<Product> fetchedProducts = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((prodId, prodData) {
        fetchedProducts.insert(
            0,
            Product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              price: prodData['price'],
              imageUrl: prodData['imageUrl'],
              isFavourite: prodData['isFavourite'],
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
    bool isFavourite,
  ) async {
    final url = Uri.https(_authority, _productsEndPoint);

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': title,
          'description': description,
          'price': price,
          'imageUrl': imageUrl,
          'isFavourite': isFavourite,
        }),
      );

      var productId = json.decode(response.body)['name'];
      var productToAdd = Product(
        id: productId,
        title: title,
        description: description,
        imageUrl: imageUrl,
        price: price,
        isFavourite: isFavourite,
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
    bool isFavourite,
  ) {
    final url = Uri.https(_authority, _productsEndPoint);
    return http
        .post(
      url,
      body: json.encode({
        "title": title,
        "description": description,
        "price": price,
        "imageUrl": imageUrl,
        "isFavourite": isFavourite,
      }),
    )
        .then((response) {
      final product = Product(
        id: json.decode(response.body)["name"],
        title: title,
        description: description,
        price: price,
        imageUrl: imageUrl,
        isFavourite: isFavourite,
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
    final url = Uri.https(_authority, '/products/${productToEdit.id}.json');
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
        productToEdit.isFavourite,
      );
    } else {
      _items[productIndex] = productToEdit;
      notifyListeners();
    }
  }

  Future<void> deleteProductAsync(String productId) async {
    if (productId == null) return;
    final url = Uri.https(_authority, '/products/$productId');

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
    final url = Uri.https(_authority, '/products/$productId.json');
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
