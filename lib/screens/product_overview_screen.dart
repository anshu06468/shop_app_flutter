import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../widgets/appDrawer.dart';
import './../providers/cart.dart';
import './../screens/cart_screen.dart';
import 'package:shop/widgets/badge.dart';
import './../widgets/products_grid.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = '/';
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  int crossAxisCount = 2;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey();
  bool _showOnlyfav = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      drawer: AppDrawer(),
      // appBar: AppBar(

      //   title: Text("My Shop"),
      //   actions: [
      // PopupMenuButton(
      //   icon: Icon(
      //     Icons.more_vert,
      //   ),
      //   itemBuilder: (_) => [
      //     PopupMenuItem(
      //       child: Text("Only Favourites"),
      //       value: FilterOptions.Favorites,
      //     ),
      //     PopupMenuItem(
      //       child: Text("Show All"),
      //       value: FilterOptions.All,
      //     )
      //   ],
      //   onSelected: (FilterOptions selecetdValue) {
      //     setState(() {
      //       if (selecetdValue == FilterOptions.Favorites) {
      //         _showOnlyfav = true;
      //       } else {
      //         _showOnlyfav = false;
      //       }
      //     });
      //   },
      // ),
      // Consumer<Cart>(
      //   builder: (_, cartData, ch) {
      //     return Badge(
      //       child: ch,
      //       value: cartData.itemCount.toString(),
      //     );
      //   },
      //   child: IconButton(
      //     icon: Icon(Icons.shopping_cart),
      //     onPressed: () {
      //       Navigator.of(context).pushNamed(CartScreen.routeName);
      //     },
      //   ),
      // ),
      //   ],
      // ),
      appBar: PreferredSize(
        child: Container(
          // height: 80,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    _scaffoldkey.currentState.openDrawer();
                  },
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                ),
                Text(
                  'My Shop',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                Spacer(),
                PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                  ),
                  color: Colors.black,
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text(
                        "Only Favourites",
                        style: TextStyle(color: Colors.white70),
                      ),
                      value: FilterOptions.Favorites,
                    ),
                    PopupMenuItem(
                      child: Text("Show All",
                          style: TextStyle(color: Colors.white70)),
                      value: FilterOptions.All,
                    )
                  ],
                  onSelected: (FilterOptions selecetdValue) {
                    setState(() {
                      if (selecetdValue == FilterOptions.Favorites) {
                        _showOnlyfav = true;
                      } else {
                        _showOnlyfav = false;
                      }
                    });
                  },
                ),
                Consumer<Cart>(
                  builder: (_, cartData, ch) {
                    return Badge(
                      child: ch,
                      value: cartData.itemCount.toString(),
                    );
                  },
                  child: IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.of(context).pushNamed(CartScreen.routeName);
                    },
                  ),
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff821c29), Colors.black87],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
              boxShadow: [
                // BoxShadow(
                //   color: Colors.grey[500],
                //   blurRadius: 20.0,
                //   spreadRadius: 1.0,
                // )
              ]),
        ),
        preferredSize: Size(MediaQuery.of(context).size.width, 150.0),
      ),
      body: Container(
        color: Colors.black87,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    icon: Icon(
                      Icons.list,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        crossAxisCount = 1;
                      });
                    }),
                IconButton(
                    icon: Icon(
                      Icons.grid_view,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        crossAxisCount = 2;
                      });
                    }),
              ],
            ),
            Expanded(
              child: ProductsGrid(_showOnlyfav, crossAxisCount),
            ),
          ],
        ),
      ),
    );
  }
}
