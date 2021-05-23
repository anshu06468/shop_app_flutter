import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../providers/Products_provider.dart';
import './products_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showfav;
  final int crossAxisCount;
  ProductsGrid(this.showfav, this.crossAxisCount);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showfav ? productsData.showFav : productsData.items;
    // print(products.length);
    if (products.length > 0)
      return GridView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: crossAxisCount == 1 ? 1.5 : 1,
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
        child: Column(
          children: [
            Image.network(
                "https://www.grabox.in/media/grabox//ohoshop_webapp/themes/shopper/assets/android/img/empty_product.svg"),
            Text(
              "No Products",
              style: TextStyle(fontSize: 20, color: Colors.grey),
            )
          ],
        ),
      );
  }
}
