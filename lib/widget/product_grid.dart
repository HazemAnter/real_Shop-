import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_shop/providers/products.dart';
import 'package:real_shop/widget/product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool shoFav;

  ProductGrid(this.shoFav);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);

    final products = shoFav ? productData.favoriteItems : productData.items;
    return products.isEmpty
        ? Center(
            child: Text("There is no Product!"),
          )
        : GridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: products.length,
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                  value: products[i],
                  child: ProductItem(),
                ));
  }
}
