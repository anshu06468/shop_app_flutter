import 'package:flutter/material.dart';
import './../providers/orders.dart' as ord;
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text("\$${widget.order.amount}"),
            subtitle: Text(
              DateFormat('dd/mm/yyyy hh:mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(widget.order.products.length * 50.0 + 10, 180),
              // height: 1000,
              child: ListView.builder(
                  itemCount: widget.order.products.length,
                  itemBuilder: (ctx, i) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              widget.order.products[i].title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Image.network(
                              widget.order.products[i].imgSrc,
                              // scale: 15,
                              height: 40,
                              width: 40,
                              alignment: Alignment.center,

                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "${widget.order.products[i].quantity}x \$${widget.order.products[i].price}",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            )
        ],
      ),
    );
  }
}
