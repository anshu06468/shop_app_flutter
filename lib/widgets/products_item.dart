import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';
import './../providers/cart.dart';
import './../providers/product.dart';
import './../screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prod = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    final _scaffold = ScaffoldMessenger.of(context);
    // Consumer used to stop unneceesary ruin of build
    // it helps to build only that part of data which requires that

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductDetailScreen.routeName, arguments: prod.id);
        },
        child: GridTile(
          child: Image.network(
            prod.imageUrl,
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black,
            leading: Consumer<Product>(
              builder: (ctx, prod, child) => IconButton(
                // child used with consumer holds the widget which you don't want to build during changes
                onPressed: () {
                  prod
                      .toggleFavouriteStatus(auth.token, auth.userId)
                      .catchError((error) {
                    _scaffold.hideCurrentSnackBar();
                    _scaffold.showSnackBar(SnackBar(
                      content: Text(error.toString()),
                      duration: Duration(seconds: 2),
                    ));
                  });
                },
                // label:child
                icon: Icon(
                  prod.isFavourite ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).accentColor,
                ),
              ),
              child: Text("hi"),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {
                cart.addItem(prod.id, prod.price, prod.title, prod.imageUrl);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: Duration(seconds: 2),
                  content: Text("Added item to the cart"),
                  action: SnackBarAction(
                      label: "UNDO",
                      onPressed: () {
                        cart.removeSingleItem(prod.id);
                      }),
                ));
              },
            ),
            title: Text(
              prod.title,
              style: TextStyle(
                fontSize: 12,
              ),
              overflow: TextOverflow.visible,
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
