import 'package:belanja_app/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<Products>(context);
    final product = providerData.items;
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 3 / 2,
            mainAxisExtent: 150),
        padding: const EdgeInsets.all(10),
        itemCount: product.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider(
              create: (context) => product[i],
              child: ProductItem(),
            ));
  }
}