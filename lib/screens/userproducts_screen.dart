import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../screens/edit_product_screen.dart';
import './../widgets/appDrawer.dart';
import './../widgets/userProductItem.dart';
import './../providers/Products_provider.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = "/user-products";

  Future<void> _refreshPage(BuildContext context) async {
    return await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //final productList = Provider.of<Products>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refreshPage(context),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _refreshPage(context),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Consumer<Products>(
                    builder: (BuildContext context, productList, Widget child) {
                      return ListView.builder(
                          itemCount: productList.items.length,
                          itemBuilder: (_, i) {
                            return Column(
                              children: [
                                UserProductItem(
                                  productList.items[i].id,
                                  productList.items[i].title,
                                  productList.items[i].imageUrl,
                                ),
                                Divider(
                                  // color: Colors.black,
                                  thickness: 1,
                                ),
                              ],
                            );
                          });
                    },
                  ),
                ),
              ),
      ),
    );
  }
}
