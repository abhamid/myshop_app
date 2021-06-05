import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/product.dart';
import './product_item.dart';
import '../providers/products.dart';

class ProductGridView extends StatelessWidget {
  const ProductGridView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final loadedProducts = productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: loadedProducts.length,
      itemBuilder: (ctx, index) {
        final Product product = loadedProducts[index];
        return ProductItem(
          id: product.id,
          title: product.title,
          imgUrl: product.imageUrl,
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
