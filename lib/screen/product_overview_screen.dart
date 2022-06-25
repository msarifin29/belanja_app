import 'package:belanja_app/widgets/product_grid.dart';
import 'package:flutter/material.dart';

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
                      PopupMenuItem(
                        child: Text('MyFavorite'),
                        value: FilterOptions.MyFavorite,
                      ),
                      PopupMenuItem(
                        child: Text('All'),
                        value: FilterOptions.All,
                      )
                    ])
          ],
        ),
        body: ProductGrid(
          productFavs: _showOnlyFavorite,
        ));
  }
}
