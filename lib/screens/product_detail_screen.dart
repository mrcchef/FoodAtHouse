import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_package.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail-screen';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    // listen is a field available in the of() method and
    // listen :flase singifies that with the change in ProductPackage it should not get rebuild
    // default is set true and with the change, it get rebuild
    final loadedProduct = Provider.of<ProductPackage>(context, listen: false)
        .searchById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              // margin: EdgeInsets.all(10),
              child: Image.network(
                loadedProduct.imageUrl,
                fit: BoxFit.cover,
                height: 300,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '\$${loadedProduct.price}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Container(
              width: double.infinity,
              // alignment: Alignment.center,
              child: Text(
                loadedProduct.description,
                style: TextStyle(
                  fontSize: 20,
                ),
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
