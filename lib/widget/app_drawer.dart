import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../screens/orders_screen.dart';
import '../screens/user_product_screen.dart';

class AppDrawer extends StatelessWidget {
  //const AppDrawer({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: <Widget>[
        AppBar(
          title: Text('My Account'),
          automaticallyImplyLeading: false,
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text(
            'Shop',
            style: Theme.of(context).textTheme.title,
          ),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.payment),
          title: Text(
            'Orders',
            style: Theme.of(context).textTheme.title,
          ),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text('User Products'),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(UserProductScreen.routeName);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('Logout'),
          onTap: () {
            Navigator.of(context).pop();
            Provider.of<Auth>(context, listen: false).logOut();
          },
        ),
      ],
    ));
  }
}
