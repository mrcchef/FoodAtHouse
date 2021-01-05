import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/edit_products.dart';
import './screens/user_product_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/product_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/orders.dart';
import './providers/product_package.dart';
import './providers/cart.dart';

void main() {
  runApp(MyApp());
}

// Now here we have to add provider class for that we wrap our MaterialApp Widget with
// Provider class
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // MultiProvider is a widget that groups multiple providers
      // through the providers field which takes a list Provides as input
      // Although we could also do nesting of Provider but this is the best practice
      providers: [
        ChangeNotifierProvider(
          // this is a Provider class which creates a new
          // instance of Product provider class b/c this is where we have implemented our provider
          // logic and that is why we have passed the instance  at the create field
          // When ever the our data get updated it creates a new instance of our provider class
          // and rebuild only those classes which are listening it i.e. it will not rebuild our main
          // class
          // Since we are passing the instance of our provider class then we can use
          // Provider.of<ProductPackage>(context);
          //the type as ProductPackage
          // we can also use .value constructor as we have done in products_grid but create
          // method is much more efficient
          create: (ctx) => ProductPackage(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
      ],
      child: MaterialApp(
        title: 'Shop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          UserProductScreen.routeName: (ctx) => UserProductScreen(),
          EditProduct.routeName: (ctx) => EditProduct(),
        },
      ),
    );
  }
}
