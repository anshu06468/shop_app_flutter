import 'package:flutter/material.dart';
import 'package:shop/screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  final String imgUrl;
  final String id;
  final String title;

  ProductItem(this.imgUrl, this.id, this.title);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductDetailScreen.routeName, arguments: id);
        },
        child: GridTile(
          child: Image.network(
            imgUrl,
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.favorite,
                color: Theme.of(context).accentColor,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {},
            ),
            title: Text(
              title,
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
