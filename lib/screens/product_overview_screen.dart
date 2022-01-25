import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_shop/providers/cart.dart';
import 'package:real_shop/providers/products.dart';
import 'package:real_shop/screens/cart_screen.dart';
import 'package:real_shop/widget/badge.dart';
import 'package:real_shop/widget/product_grid.dart';

import '../widget/app_drawer.dart';

enum FilterOption { Favorite, All }

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = '/Product-overview';

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _isLoading = false;
  var _showOnlyFavorite = false;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts()
        .then((_) => setState(() {
              _isLoading = false;
            }))
        .catchError((error) => setState(() {
              _isLoading = false;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
              onSelected: (FilterOption selectedVal) {
                setState(() {
                  if (selectedVal == FilterOption.Favorite) {
                    _showOnlyFavorite = true;
                  } else {
                    _showOnlyFavorite = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text("Show all"),
                      value: FilterOption.All,
                    ),
                    PopupMenuItem(
                      child: Text("Only Favorite"),
                      value: FilterOption.Favorite,
                    ),
                  ]),
          Consumer<Cart>(
            child: IconButton(
                onPressed: () =>
                    Navigator.of(context).
                    pushNamed(CartScreen.routeName),
                icon: Icon(Icons.shopping_cart)),
            builder: (_, cart, ch) =>
                Badage(value: cart.itemCount.toString(), child: ch!),
          ),
        ],
        title: Text("My Shop"),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showOnlyFavorite),
      drawer: AppDrawer(),
    );
  }
}
