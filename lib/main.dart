import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/auth.dart';
import './providers/cart.dart';
import './providers/orders.dart';

import './providers/products.dart';
import './screens/edit_product_screen.dart';
import './screens/order_screen.dart';
import './screens/splash_screen.dart';
import './screens/user_products_screen.dart';
import './screens/auth_screen.dart';
import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/product_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
            create: (_) => Products(),
            update: (ctx, authVal, previousProducts) => previousProducts!
                ..getData(authVal.token , authVal.userId,
                    previousProducts.items)),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
            create: (_) => Orders(),
            update: (ctx, authVal, previousOrders) => previousOrders!..getData(
                authVal.token,
                authVal.userId,
                previousOrders.orders)),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
            ),
            home: auth.isAuth
                ? ProductOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authSnapshot) =>
                        authSnapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
              ProductOverviewScreen.routeName: (context) =>
                  ProductOverviewScreen(),
              CartScreen.routeName: (context) => CartScreen(),
              OrderScreen.routeName: (context) => OrderScreen(),
              UserProductsScreen.routeName: (context) => UserProductsScreen(),
              SplashScreen.routeName: (context) => SplashScreen(),
              AuthScreen.routeName: (context) => AuthScreen(),
              EditProductScreen.routeName: (context) => EditProductScreen(),
            }),
      ),
    );
  }
}
