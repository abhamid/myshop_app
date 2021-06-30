import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_item.dart';
import '../providers/products.dart';

class ProductGridView extends StatelessWidget {
  final showOnlyFavourites;
  const ProductGridView({
    this.showOnlyFavourites,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final loadedProducts = this.showOnlyFavourites
        ? productsData.favouriteItems
        : productsData.items;
    return loadedProducts.length <= 0
        ? Center(
            child: Text(
              'No Products Found',
              style: Theme.of(context).textTheme.title,
            ),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: loadedProducts.length,
            itemBuilder: (ctx, index) {
              return ChangeNotifierProvider.value(
                value: loadedProducts[index],
                child: ProductItem(),
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
          );
  }
}
