import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  int quantity;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.price,
    this.quantity = 1,
  });
}

class Cart with ChangeNotifier {
  // Since id of cartItem would not be equal to the product id so we mapped
  // the product id with the CardItem
  Map<String, CartItem> _items = {};

  void addItem(String itemId, String itemTitle, double itemPrice) {
    if (_items.containsKey(itemId)) {
      _items.update(
        itemId,
        (previousItem) => CartItem(
          id: previousItem.id,
          price: previousItem.price,
          title: previousItem.title,
          quantity: previousItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        itemId,
        () => CartItem(
          id: DateTime.now().toString(),
          price: itemPrice,
          title: itemTitle,
        ),
      );
      // print(_items.length);
    }
    notifyListeners();
  }

  Map<String, CartItem> get getItems {
    return {..._items};
  }

  int get getTotalCartItem {
    return _items.length;
  }

  double get getTotalAmount {
    double sum = 0;
    _items.forEach((productId, item) {
      sum += item.price * item.quantity;
    });
    return sum;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) // .containsKey return true or false
      return;

    if (_items[productId].quantity > 1) {
      _items.update(
        // .update the map for the prodvided key of map
        productId,
        (existingValue) => CartItem(
          // funtion return new updated instance value of key
          id: existingValue.id, // it accepts the previous value of CartItem
          title: existingValue.title,
          price: existingValue.price,
          quantity: existingValue.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId); // removes key :- productId from the map
    }
  }
}
