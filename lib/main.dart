import 'package:belanja_app/provider/cart.dart';
import 'package:belanja_app/provider/order.dart';
import 'package:belanja_app/provider/products.dart';
import 'package:belanja_app/screen/cart_screen.dart';
import 'package:belanja_app/screen/edit_product_screen.dart';
import 'package:belanja_app/screen/order_screen.dart';
import 'package:belanja_app/screen/product_detail_screen.dart';
import 'package:belanja_app/screen/product_overview_screen.dart';
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
        ChangeNotifierProvider(create: (ctx) => Products()),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(create: (ctx) => Orders())
      ],
      child: MaterialApp(
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                .copyWith(secondary: Colors.deepOrange),
            fontFamily: 'Lato'),
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/product-detail': (context) => const ProductDetailScreen(),
          '/cart': (context) => const CartScreen(),
          '/orders': (context) => const OrderScreen(),
          '/user-product': (context) => const UserProducrScreen(),
          '/edit-product': (context) => const EditProductScreen(),
        },
        home: const ProductsOverviewScreen(),
      ),
    );
  }
}
