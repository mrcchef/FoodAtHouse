import 'package:flutter_shop/providers/cart.dart';

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

  List<OrderItem> get getOrderList {
    return [..._orderList];
  }

  // int get getProductsLength {
  //   return _orderList.length;
  // }

  void add(List<CartItem> placedOrders, double totalAmount) {
    _orderList.insert(
      0,
      OrderItem(
        dateTime: DateTime.now(),
        amount: totalAmount,
        id: DateTime.now().toString(),
        products: placedOrders,
      ),
    );
  }
}
