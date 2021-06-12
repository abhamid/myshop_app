import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';

import '../widget/order_item.dart';
import '../widget/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/OrdersScreen';
  //const OrdersScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context).items;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (ctx, index) => OrderItem(
          orderItem: orders[index],
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
