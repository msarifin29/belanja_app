import 'package:belanja_app/provider/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Chip(
                      label: Text('\$${cart.totalAmount}'),
                      labelStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    TextButton(onPressed: () {}, child: Text('Order Now'))
                  ]),
            ),
          )
        ],
      ),
    );
  }
}
