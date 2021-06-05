import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  //const ProductDetailScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    final productId = routeArgs['id'];
    final productTitle = routeArgs['title'];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          productTitle,
        ),
      ),
    );
  }
}
