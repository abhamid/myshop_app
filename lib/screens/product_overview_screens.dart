import 'package:flutter/material.dart';

import '../widget/product_grid_view.dart';

class ProductOverViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
      ),
      body: ProductGridView(),
    );
  }
}
