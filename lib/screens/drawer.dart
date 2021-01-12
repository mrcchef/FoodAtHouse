import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_shop/providers/auth.dart';
import './orders_screen.dart';
import './user_product_screen.dart';

class DrawerBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            height: 150,
            width: double.infinity,
            child: Center(
              child: Text(
                "Hello Shoppers!!",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
                // textAlign: TextAlign.center,
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text(
              'Shop',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.list),
            title: Text(
              'Orders',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.list),
            title: Text(
              'Manage Product',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(
              'Logout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              // b/c we want to logout the user so, we popped the screen and
              // clear all labels in the Auth.dart file
              Navigator.of(context).pop();
              // This ensures that every time we logout so the some page will open
              // and the logic at homepage will execute
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
          // InkWell(),
        ],
      ),
    );
  }
}
