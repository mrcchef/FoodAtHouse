import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // to avoid naming clashes
import '../models/http_exception.dart';

import 'products.dart';

// we need to provide this class to the parent of all the widgets which are actually accessing
// our data and since, we have registered are routes on main then we have to provide there on the
// main class
class ProductPackage with ChangeNotifier {
  List<Product> _items =
      []; // Now we are working on Firebase server so we don't need the dummy data
  //   Product(
  //     id: 'p1',
  //     title: 'Red Shirt',
  //     description: 'A red shirt - it is pretty red!',
  //     price: 29.99,
  //     imageUrl:
  //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  //   ),
  //   Product(
  //     id: 'p2',
  //     title: 'Trousers',
  //     description: 'A nice pair of trousers.',
  //     price: 59.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
  //   ),
  //   Product(
  //     id: 'p3',
  //     title: 'Yellow Scarf',
  //     description: 'Warm and cozy - exactly what you need for the winter.',
  //     price: 19.99,
  //     imageUrl:
  //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
  //   ),
  //   Product(
  //     id: 'p4',
  //     title: 'A Pan',
  //     description: 'Prepare any meal you want.',
  //     price: 49.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
  //   ),
  // ];

  final String authToken;
  final String userId;

  ProductPackage(this.authToken, this.userId, this._items);

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

  Future<void> updateItems(String productId, Product newProduct) async {
    // Now to update a product we have to focus on the specific id in the URL
    // patch() method is there which again take a url and a body where we provide
    // our updated product
    // If there is a element which we are not possing in the patch body then
    // the value of that element remains same
    final url =
        'https://flutter-shop-9346a-default-rtdb.firebaseio.com/products/$productId.json?auth=$authToken';
    var index = _items.indexWhere((element) => element.id == productId);
    if (index >= 0) {
      await http.patch(
        url,
        body: json.encode(
          {
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          },
        ),
      );
      _items[index] = newProduct;
    } else {
      //.....
    }
    notifyListeners();
  }

  // In deletion we used the method called delete() provided by the http package
  // It onlu require a single parament i.e. url
  // Since, If any error occur's while deleting the product, it actually does not
  // return it, so we and explicitly returning an error
  // Status code >=400 means some error accured so, we check that condition and
  // threw an custom error
  // and in the catchError section we have added that product again to our list
  // and If the deletion was succesfull then we make our backup variable as null
  // and flutter automatically remove those data which are not being using in the app

  // ABove explanation is based on then() and catchHere() methods but not below is
  // implement throw async and await method
  // First we have store that element for backup
  // then we have deleted it and perform http delete request
  // and if the resposeCOde is greater than 400 then indert than element again
  // throw the custom exception

  Future<void> removeItem(String productId) async {
    final url =
        'https://flutter-shop-9346a-default-rtdb.firebaseio.com/products/$productId.json?auth=$authToken';
    var index = _items.indexWhere((element) => element.id == productId);
    var toDeleteProduct = _items[index];
    _items.removeAt(index);
    notifyListeners();

    final response = await http.delete(url);
    print(response.statusCode);

    if (response.statusCode >= 400) {
      _items.insert(index, toDeleteProduct);
      notifyListeners();
      throw HttpException('Deletion Failed!!');
    }
    toDeleteProduct = null;
  }

  // We have made addProduct() method as Future b/c in the saveForm() method in  edit_products.dart class,
  // we want to pop current edit_screen when the execution of addProduct method ends i.e.
  // when new product is succesfully added in our web server

  // We have a alternative synatx while working with Future objects
  // which is using async and await keyword
  // async keyword makes the entire method as Future method which will return a Future object automatically
  // await method will make the code below it asynchronous.
  // code below await will be execute after the execution of await method
  // If something is returing from the Future method then we can recieve it through variable

  Future<void> addProduct(Product product) async {
    // Setup a url through which we will do our queries in our servers
    //   eg: - url + <folder name>.json
    // here products is the folder name
    final url =
        'https://flutter-shop-9346a-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    // Now we will use post method which will add data in products folder in our database
    // post() method takes two arguments
    // 1st is the url then 2nd is the body where we have to send our data in json formaat
    // using json.encode() method we can encoding our data into json but we can not directly pass our object
    // it can take string, list,map,etc.

    // we can use try and catch to handle error
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'userId': userId,
          },
        ),
      );
      // .then((response) {
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
        isFavourite: product.isFavourite,
      );
      _items.add(itemProduct);
      notifyListeners(); // this is a method which notify only all the classes that are using
      // provider package get's rebuild and get's the updated list of products
      // and also if we update our list outside the class then we would not able to call notifyListners
      // and the classes which are using data cannot be rebuild and get access to updated data
    } catch (error) {
      print(error);
      throw error;
    }
  }

  // We need to fetch all the products in the products overview screen but in the
  // manage user product screen, user product should be there
  // To implement this feature I have used a optional filterByUser variable
  // which will be responsible to execute which type of filering we want
  // fiterString containes empty if we don't want to filter otherwise,
  // we have filtring logic for firebase and also we need to do some necessary change in the rules of database
  // Logic: We have added one more field called products(folder name where we need to filter)
  // Now it accepts a map and Key is .indexOn which is understood by firebase
  // value will ricieve a list of field we need to filter
  // It looks like "products":{".indexOn":["userId"]},
  Future<void> fetchAndShowProducts([bool filterByUser = false]) async {
    String filterString =
        filterByUser ? 'orderBy="userId"&equalTo="$userId"' : '';
    var url =
        'https://flutter-shop-9346a-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      // TO make sure favourites of particular user is visible at product overview
      // page, for that we have created one data field for favourites
      // well the folder is userFavourite and inside it we have userId of the user
      // and then for all the products we have a value true and false
      final response = await http.get(url);
      url =
          'https://flutter-shop-9346a-default-rtdb.firebaseio.com/userFavourite/$userId.json?auth=$authToken';
      final favouriteResponse = await http.get(url);
      final favouriteData = json.decode(favouriteResponse.body);
      // print(favouriteData);
      final List<Product> extractedProduct = [];
      // extractedData is a Map of productId and a Map constituing of productData
      final Map<String, dynamic> extractedData = json.decode(response.body);
      extractedData.forEach((prodId, prodData) {
        extractedProduct.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavourite:
                // favoriteData == null signifies if there are not favoutire data
                // fovouriteData[prodId]:- true or false for the prdocut havind product if
                // ?? operator is used to check favouriteData[prodId] is null or not
                favouriteData == null ? false : favouriteData[prodId] ?? false,
          ),
        );
        // After extracting we have updated our List of product
        _items = extractedProduct;
        notifyListeners();
      });
      // print(json.decode(response.body));
    } catch (error) {
      print(error);
    }
  }
}
