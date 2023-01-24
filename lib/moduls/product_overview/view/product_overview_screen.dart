import 'package:belanja_app/moduls/cart/view_model/cart.dart';
import 'package:belanja_app/utils/common_widgets/app_drawer.dart';
import 'package:belanja_app/utils/common_widgets/badge.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/share/product_provider/products.dart';
import '../widgets/product_grid.dart';

// ignore: constant_identifier_names
enum FilterOptions { MyFavorite, All }

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavorite = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      // context.read<Products>().fetchAndSetProducts().then((_) {
      //   setState(() {
      //     _isLoading = false;
      //   });
      // });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Belanja',
        ),
        centerTitle: true,
        actions: [
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/cart');
                },
                icon: const Icon(Icons.shopping_cart_outlined),
              ),
              value: cart.itemCount.toString(),
            ),
          ),
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
              ),
            ],
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(
              productFavs: _showOnlyFavorite,
            ),
    );
  }
}
