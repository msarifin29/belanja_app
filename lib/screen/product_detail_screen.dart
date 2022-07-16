import 'package:belanja_app/provider/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title!),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Hero(
              tag: loadedProduct.id!,
              child: Image.network(
                loadedProduct.imageUrl!,
                fit: BoxFit.cover,
              ),
            ),
          ),
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
          )
        ],
      )),
    );
  }
}
