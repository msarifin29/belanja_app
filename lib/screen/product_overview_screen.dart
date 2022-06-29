import 'package:belanja_app/provider/cart.dart';
import 'package:belanja_app/widgets/app_drawer.dart';
import 'package:belanja_app/widgets/badge.dart';
import 'package:belanja_app/widgets/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: constant_identifier_names
enum FilterOptions { MyFavorite, All }

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavorite = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Belanja',
          ),
          actions: [
            Consumer<Cart>(
                builder: (_, cart, ch) => Badge(
                      child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/cart');
                          },
                          icon: const Icon(Icons.shopping_cart_outlined)),
                      value: cart.itemCount.toString(),
                    )),
            PopupMenuButton(
                onSelected: (FilterOptions selectedValue) {
                  setState(() {
                    if (selectedValue == FilterOptions.MyFavorite) {
                      _showOnlyFavorite = true;
                    } else {
                      _showOnlyFavorite = false;
                    }
                  });
                },
                itemBuilder: (_) => [
                      const PopupMenuItem(
                        child: Text('MyFavorite'),
                        value: FilterOptions.MyFavorite,
                      ),
                      const PopupMenuItem(
                        child: Text('All'),
                        value: FilterOptions.All,
                      )
                    ])
          ],
        ),
        drawer: const AppDrawer(),
        body: ProductGrid(
          productFavs: _showOnlyFavorite,
        ));
  }
}
