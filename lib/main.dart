import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/edit_products.dart';
import './screens/user_product_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/product_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/splash_screen.dart';
import './providers/orders.dart';
import './providers/product_package.dart';
import './providers/cart.dart';
import './providers/auth.dart';
import './screens/auth_screen.dart';

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
          create: (ctx) => Auth(),
        ),
        // Since, we have a dependency on ProductPackage class so we used
        // another version of ChangeNotifierProvider() and which is
        // ChangeNotifierProxyProvider<>()
        // It is generic and recivers two type
        // 1st:- It is the class upon which ProductPackage() depends
        // 2nd:- The class which actually depends on 1st one
        // Inside in we have an update field which accepts a function
        // that function returns dependent class instance
        // It accepts three acgument,
        // 1st:- context ,
        // 2nd:- Object of class upon which ProuctPackage depends
        // 3rd:- Object of previous State of dependend class
        // Intially it will be null b/c there would not be any previous state
        // Note:- The class upon which it depends, it's provider should be available
        // already there above there widgets
        ChangeNotifierProxyProvider<Auth, ProductPackage>(
          update: (ctx, auth, previousProductPackage) {
            return ProductPackage(
              auth.getToken,
              auth.getUserId,
              previousProductPackage == null
                  ? []
                  : previousProductPackage.getProduts,
            );
          },
        ),
        // Bottom implementation is perfectly fine but now our ProductPackage()
        // is depends upon another Provider so we need to used another version of
        // ChangeNotifierProvider() and that version is implemented above

        // ChangeNotifierProvider()
        //   // this is a Provider class which creates a new
        //   // instance of Product provider class b/c this is where we have implemented our provider
        //   // logic and that is why we have passed the instance  at the create field
        //   // When ever the our data get updated it creates a new instance of our provider class
        //   // and rebuild only those classes which are listening it i.e. it will not rebuild our main
        //   // class
        //   // Since we are passing the instance of our provider class then we can use
        //   // Provider.of<ProductPackage>(context);
        //   //the type as ProductPackage
        //   // we can also use .value constructor as we have done in products_grid but create
        //   // method is much more efficient
        //   create: (ctx) => ProductPackage(),
        // ),
        // ChangeNotifierProxyProvider<Auth, Cart>(
        //   update: (ctx, auth, previousCart) {
        //     return Cart(auth.getToken,
        //         previousCart == null ? [] : previousCart.getItems);
        //   },
        // ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrders) {
            return Orders(auth.getToken, auth.getUserId,
                previousOrders == null ? [] : previousOrders.getOrderList);
          },
        ),
        // ChangeNotifierProvider(
        //   create: (ctx) => Orders(),
        // ),
      ],
      // Basically here we want to open ProductOverviewScreen and AuthScreen
      // depending upon user has logined or not
      // Here we have used Consumer<> Widget to get access out authentication
      // status and depending upon that we will display screen
      child: Consumer<Auth>(builder: (ctx, auth, _) {
        return MaterialApp(
          title: 'Shop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth // Explantion is there at end of the widget
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          // home: ProductOverviewScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProduct.routeName: (ctx) => EditProduct(),
          },
        );
      }),
    );
  }
}

// FIrstly we check wheather user is authenticated
// If not the we will tryAutoLogin using FutureBuilder()
// If it's succesfull then our data fiels in auth class will chagne
// which will trigger to rebuild Consumer<Auth> Widget and then auth.isAuth is true
// if It does not changes i.e. nothing is stored in the device then
// it will simply open the login page
