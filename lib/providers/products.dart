import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
// import 'package:provider/provider.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    @required this.isFavourite,
  });

  void _setOldStatus(oldStatus) {
    isFavourite = oldStatus;
    notifyListeners();
  }

  Future<void> toggleFavouriteStatus() async {
    final url =
        'https://flutter-shop-9346a-default-rtdb.firebaseio.com/products/$id.json';
    bool oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    print(isFavourite);
    try {
      final response = await http.patch(
        url,
        body: json.encode(
          {
            'isFavourite': isFavourite,
          },
        ),
      );
      if (response.statusCode >= 400) _setOldStatus(oldStatus);
    } catch (error) {
      _setOldStatus(oldStatus);
    }
  }
}
