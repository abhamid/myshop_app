import 'package:flutter/material.dart';

import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imgUrl;

  ProductItem({
    this.id,
    this.title,
    this.imgUrl,
  });

  void _setectProduct(BuildContext context) {
    Navigator.of(context).pushNamed(ProductDetailScreen.routeName, arguments: {
      'id': this.id,
      'title': this.title,
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () => _setectProduct(context),
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
                  Icons.favorite,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {},
              ),
              title: Text(
                this.title,
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
