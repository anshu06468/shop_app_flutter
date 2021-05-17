import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';

class CardItem extends StatelessWidget {
  final String id;
  final double price;
  final int quantity;
  final String title;
  final String productId;

  CardItem(this.id, this.price, this.quantity, this.title, this.productId);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(id),
      confirmDismiss: (direction) {
        // Alert dialog Box
        return showDialog(
            context: context,
            builder: (c) {
              return AlertDialog(
                title: Text("Are you sure"),
                content: Text("Do you want to remove item form the cart"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(c).pop(false);
                    },
                    child: Text("No"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text("Yes"),
                  )
                ],
              );
            });
      },
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: Theme.of(context).errorColor,
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
        // print(direction);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(
                  child: Text('\$$price'),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${(price * quantity)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
