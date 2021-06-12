import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  void _setectProduct(BuildContext context, String id) {
    Navigator.of(context).pushNamed(ProductDetailScreen.routeName, arguments: {
      'id': id,
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    //final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () => _setectProduct(context, product.id),
        child: GridTile(
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
            footer: GridTileBar(
              backgroundColor: Colors.black87,
              leading: Consumer<Product>(
                builder: (context, product, child) => IconButton(
                  icon: Icon(
                    product.isFavourite
                        ? Icons.favorite
                        : Icons.favorite_outline,
                    color: Theme.of(context).accentColor,
                  ),
                  onPressed: () => product.toggleFavourite(),
                ),
              ),
              title: Text(
                product.title,
                textAlign: TextAlign.center,
              ),
              trailing: Consumer<Cart>(
                builder: (context, cart, ch) => IconButton(
                  icon: Icon(
                    cart.isProductAdded(product.id)
                        ? Icons.shopping_cart
                        : Icons.shopping_cart_outlined,
                    color: Theme.of(context).accentColor,
                  ),
                  onPressed: () {
                    cart.addItem(product.id, product.title, product.price);
                    //Scaffold.of(context).openDrawer();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'Added Item to cart',
                      ),
                      duration: Duration(seconds: 2),
                      action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () {
                            cart.removeAnItem(product.id);
                          }),
                    ));
                  },
                ),
              ),
            )),
      ),
    );
  }
}
