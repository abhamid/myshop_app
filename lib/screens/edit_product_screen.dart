import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/EditProductScreen';

  //const EditProductScreen({ Key? key }) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  String _productToEditId;
  var _didProductIdInitialized = false;
  var _isLoading = false;

  var _productToEdit = Product(
    id: null,
    title: null,
    description: null,
    price: null,
    imageUrl: null,
    isFavourite: false,
  );

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_imageUrlLostFocusListener);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_didProductIdInitialized) {
      _productToEditId = ModalRoute.of(context).settings.arguments as String;

      if (_productToEditId != null) {
        var product = Provider.of<Products>(context, listen: false)
            .findById(_productToEditId);

        if (product != null) {
          _productToEdit = Product(
            id: product.id,
            title: product.title,
            description: product.description,
            price: product.price,
            imageUrl: product.imageUrl,
            isFavourite: product.isFavourite,
          );

          _imageUrlController.text = product.imageUrl;
        }
      }

      _didProductIdInitialized = true;
    }
    super.didChangeDependencies();
  }

  void _imageUrlLostFocusListener() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('jpeg') &&
              !_imageUrlController.text.endsWith('jpg') &&
              !_imageUrlController.text.endsWith('png'))) {
        return;
      }

      setState(() {});
    }
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.removeListener(_imageUrlLostFocusListener);
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) return;
    _form.currentState.save();
    if (_productToEdit.id == null) {
      setState(() {
        this._isLoading = true;
      });

      Provider.of<Products>(context, listen: false)
          .addProduct(
        _productToEdit.title,
        _productToEdit.description,
        _productToEdit.price,
        _productToEdit.imageUrl,
        _productToEdit.isFavourite,
      )
          .catchError((error) {
        return showDialog<Null>(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('Error Occured!'),
                content: Text('Some error occured.'),
                actions: [
                  FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          this._isLoading = false;
                        });
                      }),
                ],
              );
            });
      }).then(
        (value) {
          setState(() {
            this._isLoading = false;
          });
          Navigator.of(context).pop();
        },
      );
    } else {
      Provider.of<Products>(context, listen: false).editProduct(_productToEdit);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_productToEditId == null ? 'Add Product' : 'Edit Product'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                this._saveForm();
              }),
        ],
      ),
      body: this._isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(15),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _productToEdit.title != null
                            ? _productToEdit.title
                            : "",
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'You need to provide a tile for your prosuct';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          this._productToEdit = Product(
                            id: this._productToEdit.id,
                            title: value,
                            description: this._productToEdit.description,
                            price: this._productToEdit.price,
                            imageUrl: _productToEdit.imageUrl,
                            isFavourite: _productToEdit.isFavourite,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _productToEdit.price != null
                            ? _productToEdit.price.toStringAsFixed(2)
                            : "",
                        decoration: InputDecoration(labelText: 'price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a Price.';
                          }

                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }

                          if (double.parse(value) <= 0) {
                            return 'Please enter a price greater than zer0';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          this._productToEdit = Product(
                            id: this._productToEdit.id,
                            title: this._productToEdit.title,
                            description: this._productToEdit.description,
                            price: double.parse(value),
                            imageUrl: _productToEdit.imageUrl,
                            isFavourite: _productToEdit.isFavourite,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _productToEdit.description != null
                            ? _productToEdit.description
                            : "",
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide product description';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          this._productToEdit = Product(
                            id: this._productToEdit.id,
                            title: this._productToEdit.title,
                            description: value,
                            price: this._productToEdit.price,
                            imageUrl: _productToEdit.imageUrl,
                            isFavourite: _productToEdit.isFavourite,
                          );
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            child: Container(
                                padding: EdgeInsets.all(2),
                                child: _imageUrlController.text.isEmpty
                                    ? Text(
                                        'Enter an URL',
                                        textAlign: TextAlign.center,
                                      )
                                    : FittedBox(
                                        child: Image.network(
                                            _imageUrlController.text),
                                        fit: BoxFit.cover,
                                      )),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Image Url'),
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.url,
                              controller: _imageUrlController,
                              onEditingComplete: () {
                                setState(() {});
                              },
                              focusNode: _imageUrlFocusNode,
                              onFieldSubmitted: (value) => this._saveForm(),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please provide image url';
                                }

                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'Please provide valid image url';
                                }

                                if (!value.endsWith('jpeg') &&
                                    !value.endsWith('jpg') &&
                                    !value.endsWith('png')) {
                                  return 'Please provide valid image url';
                                }

                                return null;
                              },
                              onSaved: (value) {
                                this._productToEdit = Product(
                                  id: this._productToEdit.id,
                                  title: this._productToEdit.title,
                                  description: _productToEdit.description,
                                  price: this._productToEdit.price,
                                  imageUrl: value,
                                  isFavourite: _productToEdit.isFavourite,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
