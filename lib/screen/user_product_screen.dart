import 'package:belanja_app/widgets/app_drawer.dart';
import 'package:belanja_app/widgets/user_product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/products.dart';

class UserProducrScreen extends StatelessWidget {
  const UserProducrScreen({Key? key}) : super(key: key);
  static const routeName = '/user-product';

  Future<void> _refreshProducts(BuildContext context) async {
    Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your product'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  '/edit-product',
                );
              },
              icon: const Icon(Icons.add))
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView.builder(
              itemCount: productData.items.length,
              itemBuilder: (_, i) => Column(
                    children: [
                      UserProductItem(
                        id: productData.items[i].id!,
                        imageUrl: productData.items[i].imageUrl!,
                        title: productData.items[i].title!,
                      ),
                      const Divider()
                    ],
                  )),
        ),
      ),
    );
  }
}
