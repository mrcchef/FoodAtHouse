import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_package.dart';

import 'edit_products.dart';

class UserProductItem extends StatelessWidget {
  final String imageUrl;
  final String id;
  final String title;

  UserProductItem({this.id, this.imageUrl, this.title});
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
            imageUrl), // It does not take a Widget that's why we cannot
        // able to use Image.network(imageUrl) here
        // but NetworkImage(imageUrl) creates a object of that image and then it passes to the field
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProduct.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  await Provider.of<ProductPackage>(context, listen: false)
                      .removeItem(id);
                } catch (error) {
                  // Reason for declaring scafflod over future function b/c our
                  // our app already get's updated and flutter confuses that weather
                  // the context is same or updated so we so that context will be updated
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text(
                        'Deletion Failed!!!',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              },
              color: Theme.of(context).accentColor,
            )
          ],
        ),
      ),
    );
  }
}
