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
                  Spacer(),
                  CartOrderButton(cart: cart),
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

class CartOrderButton extends StatefulWidget {
  const CartOrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _CartOrderButtonState createState() => _CartOrderButtonState();
}

class _CartOrderButtonState extends State<CartOrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context, listen: false);

    return _isLoading
        ? CircularProgressIndicator()
        : FlatButton(
            onPressed: () async {
              setState(() {
                this._isLoading = true;
              });

              try {
                await orders.addOrder(
                  widget.cart.items.values.toList(),
                  widget.cart.totalPrice,
                );

                widget.cart.clear();
              } catch (error) {
                print(error);
              } finally {
                setState(() {
                  this._isLoading = false;
                });
              }
            },
            child: widget.cart.items.length > 0 ? Text('ORDER NOW') : null,
            textColor: Theme.of(context).primaryColor,
          );
  }
}
