import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './product_item.dart';

import '../providers/product_package.dart';

class ProductsGrid extends StatelessWidget {
  bool _showFav;

  ProductsGrid(this._showFav);

  @override
  Widget build(BuildContext context) {
    // It actually search for the provider class in it's anscentor widgets and int
    // our case we have declared our provider in the main class and in there in the
    // builder method we have passed the instace of our provider class.
    final productProvider = Provider.of<ProductPackage>(context);
    // productProvider is the instance of the class ProductPackage and now we can
    // access the list suing the the getters

    final loadedProducts =
        _showFav ? productProvider.getFavProducts : productProvider.getProduts;
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          // nested models of providers
          // create: (context) => // create method
          // loadedProducts[index],
          value: loadedProducts[index], // value method and both works fine
          child: ProductItem(// Imp concept here is while using nested
              // models is when even the data is changed it use the same widget
              // without creating a new, just by replacing the old data
              // since, here we are passing the object of the product so, it is already asseccible
              // to it's child class using providers package
              // instead of using builder field here we have used create field and passed the
              // referenece of the instance of product of index , index and every time Favourite is
              // toggled all the listing classes are rebuild and get the updated data

              // It is recommended to use .value constructor when we are using exesting
              // objects to avoid bugs and to improve efficiency
              // builder methods will rise to bugs which when are list is large

              // Change notifier automatically disposes the provider package data which
              // get's stored on frequent visit and it disposes when they are no longer
              //  of used
              // loadedProducts[index].id,
              // loadedProducts[index].title,
              // loadedProducts[index].imageUrl,
              ),
        );
      },
      itemCount: loadedProducts.length,
    );
  }
}
