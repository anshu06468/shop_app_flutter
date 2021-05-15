import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../providers/product.dart';
import 'package:shop/screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prod = Provider.of<Product>(context, listen: false);
    // Consumer used to stop unneceesary reun of build
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
            backgroundColor: Colors.black87,
            leading: Consumer<Product>(
              builder: (ctx, prod, child) => IconButton(
                // child used with consumer holds the widget which you don't want to build during changes
                onPressed: () {
                  prod.toggleFavouriteStatus();
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
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {},
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
