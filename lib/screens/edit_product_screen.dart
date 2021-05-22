import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../providers/Products_provider.dart';
import './../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit-product";
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _decNode = FocusNode();
  final _imgUrl = FocusNode();
  final _imageurlcontoller = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  var _initvalue = {
    "title": '',
    "description": '',
    "price": '',
    "imageUrl": '',
  };

  var _isInit = true;

  var _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    _imgUrl.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initvalue = {
          "title": _editedProduct.title,
          "description": _editedProduct.description,
          "price": _editedProduct.price.toString(),
          "imageUrl": '',
        };
        _imageurlcontoller.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imgUrl.hasFocus) {
      if (!_imgUrl.hasFocus) {
        if (_imageurlcontoller.text.isEmpty ||
            (!_imageurlcontoller.text.startsWith("http") &&
                !_imageurlcontoller.text.startsWith("https"))) {
          return;
        }
        setState(() {});
      }
    }
  }

  void _saveForm() {
    final valid = _form.currentState.validate();
    if (!valid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      Provider.of<Products>(context, listen: false)
          .addProduct(_editedProduct)
          .then((value) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      });
    }
    // print(_editedProduct.title);
    // print(_editedProduct.description);
    // print(_editedProduct.price);
    // print(_editedProduct.imageUrl);
    // print(_editedProduct.id);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _priceFocusNode.dispose();
    _decNode.dispose();
    _imageurlcontoller.dispose();
    _imgUrl.removeListener(_updateImageUrl);
    _imgUrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("sd");
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm),
        ],
      ),
      // Form Widget
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                autovalidateMode: AutovalidateMode.always,
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initvalue['title'],
                      decoration: InputDecoration(
                        labelText: "Title",
                      ),
                      // .next use to go to next field
                      textInputAction: TextInputAction.next,
                      // focus mode is use to change the focus and move to the next field
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavourite: _editedProduct.isFavourite,
                            title: value,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Enter the title";
                        }
                        return null;
                      },
                      autocorrect: true,
                    ),
                    TextFormField(
                      initialValue: _initvalue['price'],
                      focusNode: _priceFocusNode,
                      decoration: InputDecoration(
                        labelText: "Price",
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      autocorrect: true,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_decNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavourite: _editedProduct.isFavourite,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: double.parse(value),
                            imageUrl: _editedProduct.imageUrl);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter the Price";
                        }
                        if (double.tryParse(value) == null) {
                          return "Please enter the valid Price";
                        }
                        if (double.parse(value) <= 0) {
                          return "Please enter the Price greater than 0";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initvalue['description'],
                      decoration: InputDecoration(
                        labelText: "Description",
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      autocorrect: true,
                      focusNode: _decNode,
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavourite: _editedProduct.isFavourite,
                            title: _editedProduct.title,
                            description: value,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter the Description";
                        }
                        if (value.length < 10) {
                          return "Should be atleast 10 characters";
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
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
                          child: _imageurlcontoller.text.isEmpty
                              ? Center(
                                  child: Text(
                                    'Enter a Url',
                                  ),
                                )
                              : FittedBox(
                                  child: Image.network(
                                    _imageurlcontoller.text,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: "ImageUrl",
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageurlcontoller,
                            focusNode: _imgUrl,
                            onSaved: (value) {
                              _editedProduct = Product(
                                  id: _editedProduct.id,
                                  isFavourite: _editedProduct.isFavourite,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  imageUrl: value);
                            },
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter the ImageUrl";
                              }
                              if (!value.startsWith("http") &&
                                  !value.startsWith("https")) {
                                return "Please enter the valid Url";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
