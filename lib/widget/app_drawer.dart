import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_shop/providers/auth.dart';
import 'package:real_shop/screens/order_screen.dart';
import 'package:real_shop/screens/product_overview_screen.dart';
import 'package:real_shop/screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text("Hello friends"),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            title: Text("Shop"),
            leading: Icon(Icons.shop),
            onTap: ()=>Navigator.of(context).pushReplacementNamed(ProductOverviewScreen.routeName),
          ),
          Divider(),
          ListTile(
            title: Text("Orders"),
            leading: Icon(Icons.payment),
            onTap: ()=>Navigator.of(context).pushReplacementNamed(OrderScreen.routeName),
          ),
          Divider(),
          ListTile(
            title: Text("Manage Products"),
            leading: Icon(Icons.edit),
            onTap: ()=>Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName),
          ),
          Divider(),
          ListTile(
            title: Text("Logout"),
            leading: Icon(Icons.exit_to_app),
            onTap: (){
              Navigator.of(context).pop();
               Navigator.of(context).pushReplacementNamed('/');
               Provider.of<Auth>(context,listen: false).logout();
            },
          ),
        ],
      ),
    );
  }

}