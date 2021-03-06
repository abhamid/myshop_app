import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

import '../screens/edit_product_screen.dart';
import '../widget/app_drawer.dart';
import '../widget/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/UserProductScreen';
  //const UserProductScreen({ Key? key }) : super(key: key);

  Future<void> _refreshScreen(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchProductsFromServer(true);
  }

  @override
  Widget build(BuildContext context) {
    //final products = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              }),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshScreen(context),
        builder: (ctx, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapShot.error != null) {
              return Center(
                child: Text('Error Loading Products'),
              );
            } else {
              return RefreshIndicator(
                onRefresh: () => this._refreshScreen(context),
                child: Consumer<Products>(builder: (ctx, products, child) {
                  return Padding(
                    padding: EdgeInsets.all(8),
                    child: products.items.length <= 0
                        ? Center(
                            child: Text(
                              'Please Add Products',
                              style: Theme.of(context).textTheme.title,
                            ),
                          )
                        : ListView.builder(
                            itemCount: products.items.length,
                            itemBuilder: (ctx, index) {
                              return ChangeNotifierProvider.value(
                                value: products.items[index],
                                child: Column(
                                  children: [
                                    UserProductItem(),
                                    Divider(
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  );
                }),
              );
            }
          }
        },
      ),
    );
  }
}
