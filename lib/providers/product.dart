import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../model/http_exception.dart';

class Product with ChangeNotifier {
  final _authority = 'flutter-webapp-952d4-default-rtdb.firebaseio.com';

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

  Future<void> toggleFavourite(String authToken, String userId) async {
    final currentIsFavourite = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();

    try {
      final url = Uri.parse(
          'https://${this._authority}/userfavorites/$userId/${this.id}.json?auth=$authToken');

      var response = await http.put(url,
          body: json.encode(
            this.isFavourite,
          ));
      if (response.statusCode >= 400) {
        isFavourite = currentIsFavourite;
        notifyListeners();
        throw HttpException(message: 'Failed to toggle Favourite');
      }
    } catch (error) {
      isFavourite = currentIsFavourite;
      notifyListeners();
      throw error;
    }
  }
}
