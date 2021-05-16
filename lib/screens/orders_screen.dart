import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders.dart' show Orders;
import './../widgets/appDrawer.dart';
import 'package:shop/widgets/orderitem.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = "/orders";
  @override
  Widget build(BuildContext context) {
    final ordersItems = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Yours Orders"),
        ),
        drawer: AppDrawer(),
        body: ListView.builder(
          itemBuilder: (ctx, i) {
            return OrderItem(ordersItems.item[i]);
          },
          itemCount: ordersItems.item.length,
        ));
  }
}
