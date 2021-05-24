import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../providers/Products_provider.dart';
import './../screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imgSrc;

  UserProductItem(this.id, this.title, this.imgSrc);
  @override
  Widget build(BuildContext context) {
    final _scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imgSrc),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                Provider.of<Products>(context, listen: false)
                    .deleteProduct(id)
                    .catchError((onError) {
                  _scaffold.showSnackBar(SnackBar(
                      content: Text(
                    "Product not deleted",
                    textAlign: TextAlign.center,
                  )));
                  // print(onError.toString());
                });
              },
              color: Theme.of(context).errorColor,
            )
          ],
        ),
      ),
    );
  }
}
