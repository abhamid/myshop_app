import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  //const ProductDetailScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    final productId = routeArgs['id'];
    final selectedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     selectedProduct.title,
      //   ),
      // ),
      //body: SingleChildScrollView(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                selectedProduct.title,
              ),
              background: Hero(
                tag: productId,
                child: Image.network(
                  selectedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 10,
              ),
              Text(
                '\$${selectedProduct.price}',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Text(
                  selectedProduct.description,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(
                height: 300,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
