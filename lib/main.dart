import 'package:belanja_app/moduls/auth/view_model/auth.dart';
import 'package:belanja_app/moduls/cart/view_model/cart.dart';
import 'package:belanja_app/moduls/order/view_model/order.dart';
import 'package:belanja_app/utils/share/product_provider/products.dart';
import 'package:belanja_app/moduls/auth/view/auth_screen.dart';
import 'package:belanja_app/moduls/cart/view/cart_screen.dart';
import 'package:belanja_app/moduls/edit_product/view/edit_product_screen.dart';
import 'package:belanja_app/moduls/order/view/order_screen.dart';
import 'package:belanja_app/moduls/product_details/view/product_detail_screen.dart';
import 'package:belanja_app/moduls/splash/splash_screen.dart';
import 'package:belanja_app/moduls/user_product/view/user_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:belanja_app/helpers/custom_route.dart';

import 'moduls/product_overview/view/product_overview_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products('', [], ''),
          update: (context, auth, previousProducts) =>
              Products(auth.token, previousProducts!.items, auth.userId),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders('', '', []),
          update: (context, auth, previusOrders) =>
              Orders(auth.token, auth.userId, previusOrders!.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
                .copyWith(secondary: Colors.deepOrange),
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
              },
            ),
          ),
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
                          : const AuthScreen(),
                ),
        ),
      ),
    );
  }
}
