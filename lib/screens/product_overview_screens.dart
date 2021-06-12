import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/shopping_cart_screen.dart';
import '../widget/product_grid_view.dart';
import '../widget/badge.dart';
import '../providers/cart.dart';
import '../widget/app_drawer.dart';

enum FilterOptions {
  Favoutires,
  All,
}

class ProductOverViewPage extends StatefulWidget {
  @override
  _ProductOverViewPageState createState() => _ProductOverViewPageState();
}

class _ProductOverViewPageState extends State<ProductOverViewPage> {
  bool _showOnlyFavoutites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          Consumer<Cart>(
            builder: (ctx, cart, ch) =>
                Badge(child: ch, value: cart.itemCount.toString()),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(ShoppingCartScreen.routeName);
              },
            ),
          ),
          PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Ony Favourites'),
                value: FilterOptions.Favoutires,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
            onSelected: (FilterOptions selected) {
              setState(() {
                if (selected == FilterOptions.Favoutires) {
                  this._showOnlyFavoutites = true;
                } else {
                  this._showOnlyFavoutites = false;
                }
              });
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductGridView(
        showOnlyFavourites: this._showOnlyFavoutites,
      ),
    );
  }
}
