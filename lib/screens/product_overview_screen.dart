import 'package:flutter/material.dart';
import 'package:flutter_shop/screens/drawer.dart';
import 'package:provider/provider.dart';

import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../widgets/products_grid.dart';
import './cart_screen.dart';

enum menuOption {
  Favourite,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = '/overview-screen';

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showOnlyFavourite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop App'),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
            ),
            onSelected: (menuOption selectedVal) {
              if (selectedVal == menuOption.Favourite) {
                setState(() {
                  _showOnlyFavourite = true;
                });
              } else {
                setState(() {
                  _showOnlyFavourite = false;
                });
              }
            },
            itemBuilder: (ctx) {
              return [
                PopupMenuItem(
                  child: Text("Favourites"),
                  value: menuOption.Favourite,
                ),
                PopupMenuItem(
                  child: Text("All"),
                  value: menuOption.All,
                ),
              ];
            },
          ),
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              child: child,
              value: cart.getTotalCartItem.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.card_giftcard),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: DrawerBuilder(),
      body: ProductsGrid(_showOnlyFavourite),
    );
  }
}
