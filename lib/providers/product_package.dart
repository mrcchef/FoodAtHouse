import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // to avoid naming clashes

import 'products.dart';

// we need to provide this class to the parent of all the widgets which are actually accessing
// our data and since, we have registered are routes on main then we have to provide there on the
// main class
class ProductPackage with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  List<Product> get getProduts {
    // return _items; // if we simply return it then this way pointer to our list is passed
    // and any change made would refelect to your main data
    // that is why we return a copy of list
    return [..._items];
  }

  List<Product> get getFavProducts {
    return _items.where((product) => product.isFavourite == true).toList();
  }

  Product searchById(String id) {
    return _items.firstWhere((pro) => pro.id == id);
  }

  int get getProductLength {
    return _items.length;
  }

  void updateItems(String productId, Product newProduct) {
    var index = _items.indexWhere((element) => element.id == productId);
    if (index >= 0) {
      _items[index] = newProduct;
    } else {
      //.....
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    var index = _items.indexWhere((element) => element.id == productId);
    _items.removeAt(index);
    notifyListeners();
  }

  // We have made addProduct() method as Future b/c in the saveForm() method in  edit_products.dart class,
  // we want to pop current edit_screen when the execution of addProduct method ends i.e.
  // when new product is succesfully added in our web server

  Future<void> addProduct(Product product) {
    // Setup a url through which we will do our queries in our servers
    //   eg: - url + <folder name>.json
    // here products is the folder name
    const url =
        'https://flutter-shop-9346a-default-rtdb.firebaseio.com/products';
    // Now we will use post method which will add data in products folder in our database
    // post() method takes two arguments
    // 1st is the url then 2nd is the body where we have to send our data in json formaat
    // using json.encode() method we can encoding our data into json but we can not directly pass our object
    // it can take string, list,map,etc.
    return http
        .post(
      url,
      body: json.encode(
        {
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavourite': product.isFavourite,
        },
      ),
    )
        .then((response) {
      // then method is there b/c post method is a Future type
      // this post() method returns .json which contains a map in it's body
      // Here we have printer that map
      // print(json.decode(response.body));

      // Feature of this method is it executes when the associated method ends and
      // it does not terminate the remaining execution in the application and
      // after the execution of other stuff in the class it again come back to the
      // then method and then the function inside executes

      // Then function in the then method always accepts a response which is recieved from
      // the associated method
      Product itemProduct = Product(
        //here we have added our product into our dummy data
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(itemProduct);
      notifyListeners(); // this is a method which notify only all the classes that are using
      // provider package get's rebuild and get's the updated list of products
      // and also if we update our list outside the class then we would not able to call notifyListners
      // and the classes which are using data cannot be rebuild and get access to updated data
    }).catchError((error) {
      print(error);
      throw error;
    });
  }
}
