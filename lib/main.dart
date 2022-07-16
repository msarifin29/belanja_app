import 'package:belanja_app/provider/auth.dart';
import 'package:belanja_app/provider/cart.dart';
import 'package:belanja_app/provider/order.dart';
import 'package:belanja_app/provider/products.dart';
import 'package:belanja_app/screen/aut_screen.dart';
import 'package:belanja_app/screen/cart_screen.dart';
import 'package:belanja_app/screen/edit_product_screen.dart';
import 'package:belanja_app/screen/order_screen.dart';
import 'package:belanja_app/screen/product_detail_screen.dart';
import 'package:belanja_app/screen/product_overview_screen.dart';
import 'package:belanja_app/screen/splash_screen.dart';
import 'package:belanja_app/screen/user_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
              create: (_) => Products('', [], ''),
              update: (context, auth, previousProducts) =>
                  Products(auth.token, previousProducts!.items, auth.userId)),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
              create: (_) => Orders('', '', []),
              update: (context, auth, prevousOrders) =>
                  Orders(auth.token, auth.userId, prevousOrders!.orders))
        ],
        child: Consumer<Auth>(
            builder: (context, auth, _) => MaterialApp(
                theme: ThemeData(
                    colorScheme:
                        ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                            .copyWith(secondary: Colors.deepOrange),
                    fontFamily: 'Lato'),
                // initialRoute: '/',
                routes: <String, WidgetBuilder>{
                  '/product-detail': (context) => const ProductDetailScreen(),
                  '/cart': (context) => const CartScreen(),
                  '/orders': (context) => const OrderScreen(),
                  '/user-product': (context) => const UserProducrScreen(),
                  '/edit-product': (context) => const EditProductScreen(),
                  '/auth': (context) => const AuthScreen(),
                },
                home: auth.isAuth
                    ? const ProductsOverviewScreen()
                    : FutureBuilder(
                        future: auth.tryAutoLogin(),
                        builder: (context, authResultSnapshot) =>
                            authResultSnapshot.connectionState ==
                                    ConnectionState.waiting
                                ? const SplashScreen()
                                : const AuthScreen()))));
  }
}
