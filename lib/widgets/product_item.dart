import 'package:belanja_app/provider/cart.dart';
import 'package:belanja_app/provider/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/product-detail',
                  arguments: product.id);
            },
            child: FadeInImage(
              fit: BoxFit.cover,
              placeholder: const AssetImage(
                'assets/images/product-placeholder.png',
              ),
              image: NetworkImage(product.imageUrl!),
            )),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (context, product, _) => IconButton(
                onPressed: () {
                  product.toggleFavoriteStatus(
                      authData.token.toString(), authData.userId.toString());
                },
                icon: Icon(
                  product.isFavorite! ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).colorScheme.secondary,
                )),
          ),
          title: Text(
            product.title.toString(),
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
              onPressed: () {
                cart.addItem(product.id!, product.price!, product.title!);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: const Text('Berhasil ditambah ke keranjang !'),
                      duration: const Duration(seconds: 2),
                      action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            cart.removeItem(product.id!);
                          })),
                );
              },
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).colorScheme.secondary,
              )),
        ),
      ),
    );
  }
}
