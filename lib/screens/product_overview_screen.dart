import 'package:flutter/material.dart';
import 'package:flutter_shop/screens/drawer.dart';
import 'package:provider/provider.dart';

import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../widgets/products_grid.dart';
import '../providers/product_package.dart';
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
  bool _runDidDependencies = false;
  bool _isLoading = false;

  // Now we have to load our data from our server as we open our application
  // for that we have two methods to implement it either we can doit in initState
  // but we know that inside initState() we have to listen:false as show below
  // Provider.of<ProductPackage>(context, listen: false).fetchAndShowProducts();
  // and other method is usding didChangeDenendencies()
  @override
  void initState() {
    // Provider.of<ProductPackage>(context, listen: false).fetchAndShowProducts();
    super.initState();
  }

  // we should not use async in the inbuild methods istend of it we have used our previous way
  // which is using then() method
  @override
  void didChangeDependencies() {
    if (!_runDidDependencies) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductPackage>(context).fetchAndShowProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _runDidDependencies = true;
    }
    super.didChangeDependencies();
  }

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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavourite),
    );
  }
}
