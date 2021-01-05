import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import '../providers/orders.dart';

class OrderItemBuilder extends StatefulWidget {
  final OrderItem orderData;

  OrderItemBuilder(this.orderData);

  @override
  _OrderItemBuilderState createState() => _OrderItemBuilderState();
}

class _OrderItemBuilderState extends State<OrderItemBuilder> {
  bool _isExpand = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 5,
      child: Column(
        children: [
          ListTile(
            title: Text(
              '\$${widget.orderData.amount.toStringAsPrecision(4)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle:
                Text(DateFormat('dd/MM/yyyy hh:mm').format(DateTime.now())),
            trailing: IconButton(
              icon: Icon(_isExpand ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _isExpand = !_isExpand;
                  // print(_isExpand);
                });
              },
            ),
          ),
          if (_isExpand)
            Container(
              height: min(100, widget.orderData.products.length * 22.0),
              child: ListView.builder(
                itemCount: widget.orderData.products.length,
                itemBuilder: (ctx, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${widget.orderData.products[index].title}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        Text(
                            '${widget.orderData.products[index].quantity} X \$${widget.orderData.products[index].price}'),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
