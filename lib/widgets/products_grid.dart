import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../providers/Products_provider.dart';
import './products_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showfav;
  final int crossAxis_count;
  ProductsGrid(this.showfav, this.crossAxis_count);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showfav ? productsData.showFav : productsData.items;
    if (products.length > 0)
      return GridView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxis_count,
            childAspectRatio: crossAxis_count == 1 ? 1.5 : 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (ctx, index) {
            return ChangeNotifierProvider.value(
              value: products[index],
              child: ProductItem(),
            );
          });
    else
      return Center(
        child: Image.network(
          "https://lh3.googleusercontent.com/proxy/9rb29e5J4yj_zMwSxBXJnchvXb_30jUe-UrbMvM4tixnIm6L5ladaXuAmvdP_PDrpksv5K9WSOXUYMIQXCtLLGn15i1iT79Jaw",
        ),
      );
  }
}
