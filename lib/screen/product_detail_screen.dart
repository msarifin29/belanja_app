import 'package:belanja_app/provider/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    // final loadedProduct =
    //     Provider.of<Products>(context, listen: false).findById(productId);
    final loadedProduct = context.read<Products>().findById(productId);
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(loadedProduct.title!),
            background: Hero(
              tag: loadedProduct.id!,
              child: Image.network(
                loadedProduct.imageUrl!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                '\$${loadedProduct.price}',
                style: const TextStyle(fontSize: 20, color: Colors.grey),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Text(
                  loadedProduct.description.toString(),
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 900,
              )
            ],
          ),
        ])),
      ],
    ));
  }
}
