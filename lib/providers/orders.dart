import 'package:flutter_shop/providers/cart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class OrderItem {
  final String id;
  List<CartItem> products;
  final double amount;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.products,
    @required this.amount,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orderList = [];

  final String authToken;
  final String userId;
  Orders(this.authToken, this.userId, this._orderList);

  List<OrderItem> get getOrderList {
    return [..._orderList];
  }

  // In order to get those products which are particular to a user
  // for that we have created a folder of userId under orders and there we will
  // keep all our orders for userId
  Future<void> add(List<CartItem> placedOrders, double totalAmount) async {
    final url =
        'https://flutter-shop-9346a-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final DateTime timeStamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode(
        {
          'amount': totalAmount,
          'dateTime': timeStamp.toIso8601String(),
          'products': placedOrders
              .map(
                (cartItem) => {
                  'id': cartItem.id,
                  'title': cartItem.title,
                  'price': cartItem.price,
                  'quantity': cartItem.quantity,
                },
              )
              .toList(),
        },
      ),
    );
    // print(json.decode(response.body));
    _orderList.insert(
      0,
      OrderItem(
        dateTime: timeStamp,
        amount: totalAmount,
        id: json.decode(response.body)['name'],
        products: placedOrders,
      ),
    );
    notifyListeners();
  }

  Future<void> fetchAndShowProducts() async {
    final url =
        'https://flutter-shop-9346a-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(url);
    print(json.decode(response.body));
    List<OrderItem> extractedItem = [];
    var extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) return;
    extractedData.forEach(
      (orderId, orderData) {
        extractedItem.add(
          OrderItem(
            id: orderId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
            products: (orderData['products'] as List<dynamic>).map((item) {
              return CartItem(
                  id: item['id'],
                  price: item['price'],
                  title: item['title'],
                  quantity: item['quantity']);
            }).toList(),
          ),
        );
      },
    );
    _orderList = extractedItem;
    notifyListeners();
  }
}
