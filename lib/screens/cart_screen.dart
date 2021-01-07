import 'package:flutter/material.dart';
import 'package:flutter_shop/providers/orders.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../widgets/cart_list.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/Cart-screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    var children2 = <Widget>[
      Text(
        'Total',
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
      Spacer(), // this shift all the widgets below it, shifts to the right most place
      Chip(
        label: Text(
          "\$${cart.getTotalAmount.toStringAsPrecision(3)}",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      BuildOrderButton(cart: cart),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Card(
              elevation: 5,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Row(
                  children: children2,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cart.getTotalCartItem,
                itemBuilder: (ctx, index) {
                  return CartList(
                    id: cart.getItems.values.toList()[index].id,
                    title: cart.getItems.values.toList()[index].title,
                    price: cart.getItems.values.toList()[index].price,
                    quantity: cart.getItems.values.toList()[index].quantity,
                    productId: cart.getItems.keys.toList()[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuildOrderButton extends StatefulWidget {
  const BuildOrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _BuildOrderButtonState createState() => _BuildOrderButtonState();
}

class _BuildOrderButtonState extends State<BuildOrderButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget.cart.getTotalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).add(
                  widget.cart.getItems.values.toList(),
                  widget.cart.getTotalAmount);
              setState(() {
                _isLoading = false;
              });
              widget.cart.clear();
            },
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              "ORDER NOW",
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
