import 'package:flutter/material.dart';
import '../widgets/order_item_builder.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import './drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/Order-Screen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // bool _isLoading = false;

  // Here we have used initState b/c we only want to load all our orders once and
  // in the begnning of the screen
  // And for that we made it a stateful widget so that we can use it
  // Now we have alternate method using FutureBuilder widget and we can get rid
  // for state ful widget

  // void initState() {
  //   // One way doing with async and await parameter
  //   // Future.delayed(Duration.zero).then(
  //   //   (_) async {
  //   //     setState(() {
  //   //       _isLoading = true;
  //   //     });
  //   //     await Provider.of<Orders>(context, listen: false)
  //   //         .fetchAndShowProducts();
  //   //     setState(() {
  //   //       _isLoading = false;
  //   //     });
  //   //   },
  //   // );

  //   // Now we have done with then() method
  //   // _isloading is set as true b/c in the beginning only we need to load our stuff
  //   _isLoading = true;
  //   Provider.of<Orders>(context, listen: false)
  //       .fetchAndShowProducts()
  //       .then((_) {
  //     // after fetting we stopped our loading
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // Now we can not use provider here in the build method b/c as the
    // fetchAndShoeProducts method ends it will call notifyListner and then our
    // build method will rebuild's and this will ends up to a loop
    // that's why we have used Consumer Widget
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Orders!!"),
        ),
        drawer: DrawerBuilder(),
        // Future Builder is a widget's that builds content based on the
        // current staus of execution
        // in the future field it takes a Future on which he monitors it's execution
        // and then on builder field accoring to the execution status we return
        // appropriate widgets
        body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false)
              .fetchAndShowProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.error != null) {
              return Center(
                child: Text('An un expected error occured'),
              );
            } else {
              return Consumer<Orders>(
                builder: (context, orderData, child) => ListView.builder(
                  itemCount: orderData.getOrderList.length,
                  itemBuilder: (ctx, index) => OrderItemBuilder(
                    orderData.getOrderList[index],
                  ),
                ),
              );
            }
          },
        )
        // Previous method with stateful widget
        // _isLoading
        //     ? Center(
        //         child: CircularProgressIndicator(),
        //       )
        //     : ListView.builder(
        //         itemCount: orderData.getOrderList.length,
        //         itemBuilder: (ctx, index) => OrderItemBuilder(
        //           orderData.getOrderList[index],
        //         ),
        //       ),
        );
  }
}
