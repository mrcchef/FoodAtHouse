import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_package.dart';
import '../widgets/edit_products.dart';
import '../widgets/user_product_item.dart';
import './drawer.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/User-product-screen';
  @override
  Widget build(BuildContext context) {
    final productList = Provider.of<ProductPackage>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProduct.routeName);
            },
          )
        ],
      ),
      body: ListView.builder(
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
      drawer: DrawerBuilder(),
    );
  }
}
