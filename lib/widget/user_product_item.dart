import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';

class UserProductItem extends StatelessWidget {
  //const UserProductItem({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProduct = Provider.of<Product>(context, listen: false);
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
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {}),
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                onPressed: () {})
          ],
        ),
      ),
    );
  }
}
