import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  void _setectProduct(BuildContext context, String id) {
    Navigator.of(context).pushNamed(ProductDetailScreen.routeName, arguments: {
      'id': id,
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final id = product.id;
    final title = product.title;
    final imgUrl = product.imageUrl;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () => _setectProduct(context, id),
        child: GridTile(
          child: Image.network(
            imgUrl,
            fit: BoxFit.cover,
          ),
          footer: ClipRRect(
            child: GridTileBar(
              backgroundColor: Colors.black87,
              leading: IconButton(
                icon: Icon(
                  product.isFavourite ? Icons.favorite : Icons.favorite_outline,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () => product.toggleFavourite(),
              ),
              title: Text(
                title,
                textAlign: TextAlign.center,
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {},
              ),
            ),
          ),
        ),
      ),
    );
  }
}
