import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/product_overview_screens.dart';
import './screens/product_detail_screen.dart';
import './screens/shopping_cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_product_screen.dart';

import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';

import './widget/app_drawer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => Orders(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        //home: ProductOverViewPage(),
        routes: {
          '/': (ctx) => ProductOverViewPage(),
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          ShoppingCartScreen.routeName: (ctx) => ShoppingCartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          UserProductScreen.routeName: (ctx) => UserProductScreen(),
        },
      ),
    );
  }
}
