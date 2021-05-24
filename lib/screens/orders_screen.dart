import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders.dart' show Orders;
import './../widgets/appDrawer.dart';
import 'package:shop/widgets/orderitem.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = "/orders";

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future _orderFetched;

  Future _fetchOrder() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _orderFetched = _fetchOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final ordersItems = Provider.of<Orders>(context);
    // final _showsnakbar = ;
    return Scaffold(
      appBar: AppBar(
        title: Text("Yours Orders"),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _orderFetched,
        builder: (ctx, orderSnapshot) {
          if (orderSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (orderSnapshot.hasError) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                  content: Text("Something went wrong !"),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 2),
                ));
              });
              return Center(
                child: Image.network(
                    "https://www.grabox.in/media/grabox//ohoshop_webapp/themes/shopper/assets/android/img/empty_product.svg"),
              );
            } else {
              return Consumer<Orders>(builder: (ctx, ordersItems, _) {
                return ordersItems.item.length <= 0
                    ? Center(
                        child: Image.network(
                            "https://www.grabox.in/media/grabox//ohoshop_webapp/themes/shopper/assets/android/img/empty_product.svg"),
                      )
                    : ListView.builder(
                        itemBuilder: (ctx, i) {
                          return OrderItem(ordersItems.item[i]);
                        },
                        itemCount: ordersItems.item.length,
                      );
              });
            }
          }
        },
      ),
    );
  }
}
