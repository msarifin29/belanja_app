import 'package:belanja_app/provider/products.dart';
import 'package:belanja_app/screen/product_detail_screen.dart';
import 'package:belanja_app/screen/product_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Products(),
      child: MaterialApp(
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                .copyWith(secondary: Colors.deepOrange),
            fontFamily: 'Lato'),
        routes: <String, WidgetBuilder>{
          '/product-detail': (context) => ProductDetailScreen()
        },
        home: ProductsOverviewScreen(),
      ),
    );
  }
}
