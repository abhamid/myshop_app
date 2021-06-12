import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/orders.dart';
import '../widget/cart_item.dart';

class ShoppingCartScreen extends StatelessWidget {
  static const routeName = '/ShoppingCartScreen';

  //const ShoppingCartScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                          color:
                              Theme.of(context).primaryTextTheme.title.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    onPressed: () {
                      final orders =
                          Provider.of<Orders>(context, listen: false);
                      orders.addOrder(
                        cart.items.values.toList(),
                        cart.totalPrice,
                      );

                      cart.clear();
                    },
                    child: Text('ORDER NOW'),
                    textColor: Theme.of(context).primaryColor,
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
              itemCount: cart.itemCount,
              itemBuilder: (context, index) {
                var cartItem = cart.items.values.toList()[index];
                var productId = cart.items.keys.toList()[index];
                return CartItem(
                  id: cartItem.id,
                  productId: productId,
                  price: cartItem.price,
                  quantity: cartItem.quantity,
                  title: cartItem.title,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
