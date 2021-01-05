import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_package.dart';
import '../providers/products.dart';

class EditProduct extends StatefulWidget {
  static const routeName = '/Edit-Products';
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  // Here we have defined the Focus Node
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<
      FormState>(); // Global Key is rarerly used and used to communicate with the
  // widget code
  // Global key of FormState provide us functionility like save ,reset,validate form
  Product _existedProduct =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');
  var productId;
  // values map we have created to print the intial values when user want to edit the
  // existing product
  var values = {
    'title': '',
    'id': '',
    'price': '',
  };
  // we use this valiable b/c we only want to run didChangeDependencies only once
  bool _runDidChangeDependencies = true;
  // This variable is responsible for loading loading screen when our product is adding in the webserver
  // b/c http request take some time depending upon various factors and on that time we need to load
  // circularProgressBar
  bool _isLoading = false;

  void initState() {
    // here we are adding a listner to our focus node
    // as the _imageUrlFocusNode get's changed it will execute the passed function pointer
    // this we can achinve using addListner method
    _imageUrlFocusNode.addListener(updateImageUrl);
    super.initState();
  }

  void didChangeDependencies() {
    if (_runDidChangeDependencies) {
      // we are receiving id of product and if it is from edit button then
      // it will have a id otherwise null
      productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        // updating _existingProduct
        final providerData = Provider.of<ProductPackage>(context);
        _existedProduct = providerData.searchById(productId);
        values['id'] = _existedProduct.id;
        values['title'] = _existedProduct.title;
        values['description'] = _existedProduct.description;
        values['price'] = _existedProduct.price.toString();
        // Since, we are using Controller for the imageUrl then we can not use
        // intital value field in the TextFromField Widget so we have to intialize
        // controller text
        _imageUrlController.text = _existedProduct.imageUrl;
      }
    }
    _runDidChangeDependencies = false;
    super.didChangeDependencies();
  }

  // we need to remove FocusNode when the object get's cleared i.e. when the screen
  // is removed otherwise it will lead to memory leak
  void dispose() {
    // Here we are removeListener which the same reason as in case of focus node
    _imageUrlFocusNode.removeListener(updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void updateImageUrl() {
    // we just need to check weater _imageUrlFocusNode has focus or not
    // If it does not have focus then we have to render the preview of our image and
    // we need to rebuild the UI
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('https') &&
              !_imageUrlController.text.startsWith('http')) ||
          (!_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg') &&
              !_imageUrlController.text.endsWith('.png'))) return;
      setState(() {});
    }
  }

  void _saveForm() {
    // here we also have validate which will exexute all the validator field in the
    // TextFormField widgets
    bool isValid = _form.currentState.validate();
    if (!isValid) return;
    // save() method executes all functions passed at onSaved: field in every TextFormWidget
    _form.currentState.save();
    // If we have productId then we will update our List of items otherwise

    // as we are here that means we need to edit our product list so we need to display Loding Bar
    // and it should be reflected in our app UI
    setState(() {
      _isLoading = true;
    });

    if (productId != null) {
      Provider.of<ProductPackage>(context, listen: false)
          .updateItems(productId, _existedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      Provider.of<ProductPackage>(context, listen: false)
          .addProduct(_existedProduct)
          .catchError(
        (error) {
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text("ERROR!!"),
              content: Text(error.toString()),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    // setState(() {
                    //   _isLoading = false;
                    // });
                    // Navigator.of(context).pop();
                  },
                  child: Text("Okay"),
                ),
              ],
            ),
          );
        },
      ).then((_) {
        // Now we have successfully added product and now it's time to remove Progerss Bar
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      });
    }
    // Navigator.of(context).pop();
    // print(_existedProduct.id);
    // print(_existedProduct.title);
    // print(_existedProduct.description);
    // print(_existedProduct.imageUrl);
    // print(_existedProduct.price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        // Form is a invisible widget which manages all reciving inputs mechanism
        // It is a stateful widget
        child:
            _isLoading // Depending upon _isLoading we are updating our app UI
                ? Center(child: CircularProgressIndicator())
                : Form(
                    key:
                        _form, // using key we can interact with stateful properties
                    child: ListView(
                      children: <Widget>[
                        // It has a special widget TextFormField which internally linked with form
                        // and manages inpute mechanism
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Title',
                          ),
                          initialValue: values['title'],
                          // it shows the next option at keyboard
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (value) {
                            // As user submit we need to pass the pointer to next field
                            // FocusScope is used to travel to diffrent focus with in the scope
                            // using requestFocus method we have requested to move to next Focus Node
                            FocusScope.of(context)
                                .requestFocus(_priceFocusNode);
                          },
                          onSaved: (value) {
                            _existedProduct = Product(
                                title: value,
                                id: _existedProduct.id,
                                description: _existedProduct.description,
                                imageUrl: _existedProduct.imageUrl,
                                price: _existedProduct.price,
                                isFavourite: _existedProduct.isFavourite);
                          },
                          // valuw is the new value that user has inputted on the textfield
                          validator: (value) {
                            if (value.isEmpty) return 'Please provide a Title';
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Price',
                          ),
                          initialValue: values['price'],
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          // to implement a feature i.e. when user done with the text field and
                          // click on submit button, pointer should automatiically move to next textfield
                          // for that we need to define a focusNode then on the previous textField
                          // we need to pass this focusNode as user click on submit button
                          focusNode: _priceFocusNode,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_descriptionFocusNode);
                          },
                          // the function takes a argument which is the value which we recive in the
                          // text field
                          onSaved: (value) {
                            _existedProduct = Product(
                              title: _existedProduct.title,
                              id: _existedProduct.id,
                              description: _existedProduct.description,
                              imageUrl: _existedProduct.imageUrl,
                              price: double.parse(value),
                              isFavourite: _existedProduct.isFavourite,
                            );
                          },
                          validator: (value) {
                            if (value.isEmpty) return 'Please provide a Number';
                            // checks wheater we can convert string into double
                            // if no then returns null ortherwise double
                            if (double.tryParse(value) == null)
                              return 'Please Enter a valid Number';
                            if (double.parse(value) <= 0)
                              return 'Please Enter a Number greater than zero';
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Description'),
                          initialValue: values['description'],
                          // here we does not require to move to next field b/c we don't know weather
                          // the user want to move to next field or next line
                          // so we have not included textInputAction which is responsible for moving to
                          // next text field
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          focusNode: _descriptionFocusNode,
                          onSaved: (value) {
                            _existedProduct = Product(
                              title: _existedProduct.title,
                              id: _existedProduct.id,
                              description: value,
                              imageUrl: _existedProduct.imageUrl,
                              price: _existedProduct.price,
                              isFavourite: _existedProduct.isFavourite,
                            );
                          },
                          validator: (value) {
                            if (value.isEmpty)
                              return 'Please provide a Description';
                            if (value.length <= 10)
                              return 'Please write description more than 10 letters';
                            return null;
                          },
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                              ),
                              margin: EdgeInsets.only(top: 10, right: 15),
                              width: 100,
                              height: 100,
                              child: _imageUrlController.text.isEmpty
                                  ? Text('Enter URL')
                                  : FittedBox(
                                      child: Image.network(
                                        _imageUrlController.text,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            // Since Row widget does not have any contraint on the size of row and
                            // TextFormField Widget takes all the size of it's parent widget
                            // so TextFormField widget get overflowed
                            // Solution is to use Expanded Widget which will take all the avaialble
                            // spcae in the row widget
                            Expanded(
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Image URL'),
                                // initialValue: values['imageUrl'],
                                keyboardType: TextInputType.url,
                                // Now we are done with the text
                                // field so we can finally have done button
                                textInputAction: TextInputAction.done,
                                // Well usually Form widget internally
                                // manages input mechanism but here we need to dispaly the preview in the
                                // above container so we require imageUrl
                                controller: _imageUrlController,
                                // Now to add a feature that when the focus is moved to diffrenet field then
                                // also it should render the image preview and for that we need to implement
                                // our own listner
                                focusNode: _imageUrlFocusNode,
                                onFieldSubmitted: (_) => _saveForm(),
                                onSaved: (value) {
                                  _existedProduct = Product(
                                    title: _existedProduct.title,
                                    id: _existedProduct.id,
                                    description: _existedProduct.description,
                                    imageUrl: value,
                                    price: _existedProduct.price,
                                    isFavourite: _existedProduct.isFavourite,
                                  );
                                },
                                // have few doubts in the working of validate check up in updateImageUrl()  method
                                validator: (value) {
                                  if (value.isEmpty)
                                    return 'Please provide a URL';
                                  if ((!value.startsWith('https') &&
                                          !value.startsWith('http')) ||
                                      (!value.endsWith('.jpg') &&
                                          !value.endsWith('.jpeg') &&
                                          !value.endsWith('.png')))
                                    return 'Please Enter a valid URL';
                                  return null;
                                },
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
