import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../providers/Products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product_details';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 150.0),
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          // margin: EdgeInsets.only(bottom: 10),
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: Row(
              children: [
                IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                Text(
                  loadedProduct.title,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xff821c29), Colors.black87],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
        ),
      ),
      body: Container(
        color: Colors.black87,
        child: Column(children: [
          Container(
            height: 300,
            child: Image.network(
              loadedProduct.imageUrl,
              fit: BoxFit.cover,
            ),
            width: double.infinity,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "\$${loadedProduct.price}",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "${loadedProduct.description}",
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ]),
      ),
    );
  }
}
