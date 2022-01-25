import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_shop/providers/auth.dart';
import 'package:real_shop/providers/cart.dart';
import 'package:real_shop/providers/product.dart';
import 'package:real_shop/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
            child: GestureDetector(
              onTap: () => Navigator.of(context)
                  .pushNamed(ProductDetailScreen.routeName,arguments: product.id),
              child: Hero(
                tag: product.id!,
                child: FadeInImage(
                  placeholder:
                      AssetImage('assets/images/product-placeholder.png'),
                  image: NetworkImage(
                    product.imageUrl,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            footer: GridTileBar(
              backgroundColor: Colors.black87,
              leading: Consumer<Product>(
                builder: (ctx, product, _) => IconButton(
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    product.toggleFavoriteStatus(
                        authData.token, authData.userId);
                  },
                  icon: Icon(
                    product.isFavorite ? Icons.favorite : Icons.favorite_border,
                  ),
                ),
              ),
              title: Text(product.title),
              trailing: IconButton(
                color: Theme.of(context).accentColor,
                onPressed: () {
                  cart.addItem(product.id!, product.price, product.title);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("added to cart"),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      onPressed: () {
                        cart.removeSingeItem(product.id!);
                      },
                      label: 'UNDO',
                    ),
                  ));
                },
                icon: Icon(Icons.shopping_cart),
              ),
            )));
  }
}
