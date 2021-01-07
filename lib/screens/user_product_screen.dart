import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_package.dart';
import '../widgets/edit_products.dart';
import '../widgets/user_product_item.dart';
import './drawer.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/User-product-screen';

  // This is a function which will perform as we do refresh and it returns a future
  Future<void> performRefresh(ctx) async {
    await Provider.of<ProductPackage>(ctx, listen: false)
        .fetchAndShowProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productList = Provider.of<ProductPackage>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProduct.routeName);
            },
          )
        ],
      ),
      // Refresh Feature is implemented through WIdget RefreshIndicator()
      // On it's OnRefresh Field we have to pass a Future object
      body: RefreshIndicator(
        onRefresh: () {
          return performRefresh(context);
        },
        child: ListView.builder(
          itemCount: productList.getProductLength,
          itemBuilder: (ctx, index) {
            return Column(
              children: [
                UserProductItem(
                  id: productList.getProduts[index].id,
                  title: productList.getProduts[index].title,
                  imageUrl: productList.getProduts[index].imageUrl,
                ),
                Divider(),
              ],
            );
          },
        ),
      ),
      drawer: DrawerBuilder(),
    );
  }
}
