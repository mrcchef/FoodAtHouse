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
        .fetchAndShowProducts(true);
    // paramenter we is true b/c we want to filer here
  }

  // Here we need to fetch userproduct as we open the screen
  // and that's why we have used FututeBuilder
  @override
  Widget build(BuildContext context) {
    // We have used FutureBuilder and to avoid Infinite loop we used Consumer Widget
    // final productList = Provider.of<ProductPackage>(context);
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
      body: FutureBuilder(
        future: performRefresh(context),
        builder: (ctx, snapShot) {
          return snapShot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<ProductPackage>(
                  builder: (ctx, productList, child) {
                    return RefreshIndicator(
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
                                imageUrl:
                                    productList.getProduts[index].imageUrl,
                              ),
                              Divider(),
                            ],
                          );
                        },
                      ),
                    );
                  },
                  // child:
                );
        },
      ),

      drawer: DrawerBuilder(),
    );
  }
}
