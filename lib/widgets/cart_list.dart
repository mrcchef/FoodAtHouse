import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../providers/cart.dart';

class CartList extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  CartList({
    @required this.id,
    @required this.productId,
    @required this.title,
    @required this.price,
    @required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      // This is a inbuild widget that gives us a feature of removal of row // through silde
      key: ValueKey(id), // Idea of key is still confusing
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      ),
      direction: DismissDirection
          .endToStart, // setup the direction which invokes dismissels,// by defauly directin is both form left to start and start to left
      // TO show a popup alert message we have a field called confirmDismiss
      // it take dismiss direction that we have chossen
      // it returns a future bool that is after the close of the alert window it will start exexute
      // showDialog is a widget that returns a future object and it display the Dialog
      // It has two field 1st :- context which recives context of our class
      // 2nd:- builder field which has a function which return a widget
      // there are multiple Dialog widget but here we are using AlterDialog
      // in the actions field we poped out the dialog page and we return the respective value
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              'Are you sure?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text('Do you really want to remove ??'),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: Text('Yes'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: Text('No'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        // direction is the paramenter which gives us that which direction we didi sdilping
        Provider.of<Cart>(context, listen: false).removeItem(productId);
        // and on the bases od direction we can add multiple features but here it is not of our use.
      },
      child: Card(
        elevation: 3,
        margin: EdgeInsets.all(5),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: FittedBox(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    '\$$price',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ),
            title: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text(
              'Total \$${(price * quantity)}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              '${quantity}X',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
