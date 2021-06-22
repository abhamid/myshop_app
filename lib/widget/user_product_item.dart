import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';
import '../screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  //const UserProductItem({ Key? key }) : super(key: key);

  Future<void> _deleteProductWithConfirmation(
      BuildContext context, String productId) async {
    return showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Sure! You want to delete?'),
            content: Text('Do you want to dlete this product?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () async {
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .deleteProductAsync(productId);
                  } catch (error) {
                    print(error);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        error,
                        textAlign: TextAlign.center,
                      ),
                      duration: Duration(seconds: 2),
                    ));
                  }
                },
                child: Text('Yes'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final userProduct = Provider.of<Product>(context, listen: false);
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          userProduct.imageUrl,
        ),
      ),
      title: Text(userProduct.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
                color: Theme.of(context).primaryColor,
                icon: Icon(
                  Icons.edit,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProductScreen.routeName,
                      arguments: userProduct.id);
                }),
            IconButton(
              color: Theme.of(context).errorColor,
              icon: Icon(
                Icons.delete,
              ),
              onPressed: () async {
                //_deleteProductWithConfirmation(context, userProduct.id);
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProductAsync(userProduct.id);
                } catch (error) {
                  //print('$error');
                  //scaffold.hideCurrentSnackBar();
                  scaffold.showSnackBar(SnackBar(
                    content: Text(
                      'Deleting Failed',
                      textAlign: TextAlign.center,
                    ),
                    duration: Duration(
                      seconds: 2,
                    ),
                  ));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
