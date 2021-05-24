import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders.dart';
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
                      "\$${cartDetails.totalAmount.toStringAsFixed(2)}",
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
                  OrderButton(
                    cartDetails: cartDetails,
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cartDetails,
  }) : super(key: key);

  final Cart cartDetails;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cartDetails.itemCount <= 0 || _isLoading)
          ? null
          : () async {
              try {
                setState(() {
                  _isLoading = true;
                });
                await Provider.of<Orders>(context, listen: false).addOrder(
                    widget.cartDetails.items.values.toList(),
                    widget.cartDetails.totalAmount);
                setState(() {
                  _isLoading = false;
                });
              } catch (error) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(error.toString())));
              }
              widget.cartDetails.clear();
            },
      child: _isLoading ? CircularProgressIndicator() : Text("ORDER NOW"),
      style: TextButton.styleFrom(primary: Theme.of(context).primaryColor),
    );
  }
}
