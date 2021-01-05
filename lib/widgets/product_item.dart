import 'package:flutter/material.dart';
// import 'package:flutter_shop/providers/products.dart';
import 'package:provider/provider.dart';
import '../screens/product_detail_screen.dart';
import '../providers/products.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context);
    // By deafult listen is true
    // listen = false means that with the change in data it will not rebuild
    // But consumer still rebuilds
    // you can also check
    // print('Rebuild successfull');

    // Provider.of<>() rebuild the build method with the change of data and we can avoid
    // rebuilding of entire build method by efficiently splitting our build widget and then
    // use Provider.of<> there
    // But instead of it we have one more method that works exactly like Provider.of<>

    // Consumer<>() class which is similar to provider but it restrict the rebuild of
    // entire build method instead of it the widget tree that is there inside the Consumer
    // class get's rebuild

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(product.title),
          leading: Consumer<Product>(
            // It will always rebuild with the change in the data
            builder: (ctx, product, child) {
              //child is the widget that does not changes
              // with the change in data, so we have passed it here and not assign it to the
              // suitable place and now it will not rebuild everytime
              return IconButton(
                color: Theme.of(context).accentColor,
                //  suitable <field> : child
                icon: Icon(
                  product.isFavourite ? Icons.favorite : Icons.favorite_border,
                ),
                onPressed: () => product.toggleFavouriteStatus(),
              );
            },
            // child: Text('Never Changes'),
          ),
          trailing: IconButton(
            color: Theme.of(context).accentColor,
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.title, product.price);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                //Scaffod.of(context) connects to the nearest scaffold in the widget tree
                // Scaffold manages the page of application
                SnackBar(
                  // SnackBar is the widget responsible for popup of bottom info screen
                  content: Text("Item successfully added!!"),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: "UNDO",
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
