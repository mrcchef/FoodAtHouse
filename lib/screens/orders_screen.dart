import 'package:flutter/material.dart';
import '../widgets/order_item_builder.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import './drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/Order-Screen';
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders!!"),
      ),
      drawer: DrawerBuilder(),
      body: ListView.builder(
        itemCount: orderData.getOrderList.length,
        itemBuilder: (ctx, index) => OrderItemBuilder(
          orderData.getOrderList[index],
        ),
      ),
    );
  }
}
