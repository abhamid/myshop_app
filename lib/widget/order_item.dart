import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import '../model/orderitem.dart' as Ord;

class OrderItem extends StatefulWidget {
  final Ord.OrderItem orderItem;

  OrderItem({this.orderItem});

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
      height: _isExpanded
          ? min(
              widget.orderItem.products.length * 20.0 + 110,
              200,
            )
          : 95,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('\$${widget.orderItem.amount.toStringAsFixed(2)}'),
              subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm')
                    .format(widget.orderItem.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    this._isExpanded = !this._isExpanded;
                  });
                },
              ),
            ),
            //if (_isExpanded)
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeIn,
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
              height: _isExpanded
                  ? min(
                      widget.orderItem.products.length * 20.0 + 10,
                      100,
                    )
                  : 0,
              child: ListView(
                children: widget.orderItem.products
                    .map((produt) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              produt.title,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$${produt.price}x${produt.quantity}',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
