import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_shop/providers/products.dart';
import 'package:real_shop/screens/edit_product_screen.dart';
import 'package:real_shop/widget/user_product_item.dart';
import '../widget/app_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-Product-screen';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context,listen: false)
        .fetchAndSetProducts(filterByUser: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Products"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName,);
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    child: Consumer<Products>(
                      builder: (ctx, productsData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                            itemCount: productsData.items.length,
                            itemBuilder: (_, int index) => Column(
                                  children: [
                                    UserProductItem(
                                        id: productsData.items[index].id !,
                                        title: productsData.items[index].title,
                                        imageurl:
                                            productsData.items[index].imageUrl),
                                    Divider(),
                                  ],
                                )),
                      ),
                    ),
                    onRefresh: () => _refreshProducts(context)),
      ),
    );
  }
}
