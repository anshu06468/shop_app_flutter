import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../widgets/cart_item.dart';
import './../providers/cart.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart";
  @override
  Widget build(BuildContext context) {
    final cartDetails = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      "\$${cartDetails.totalCount}",
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.subtitle1.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text("ORDER NOW"),
                    style: TextButton.styleFrom(
                        primary: Theme.of(context).primaryColor),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              // ignore: missing_return
              itemBuilder: (ctx, index) {
                return CardItem(
                  cartDetails.items.values.toList()[index].id,
                  cartDetails.items.values.toList()[index].price,
                  cartDetails.items.values.toList()[index].quantity,
                  cartDetails.items.values.toList()[index].title,
                  cartDetails.items.keys.toList()[index],
                );
              },
              itemCount: cartDetails.items.length,
            ),
          )
        ],
      ),
    );
  }
}
