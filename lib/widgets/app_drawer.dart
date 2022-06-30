import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle styleText() {
      return const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
    }

    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Hello!'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: const Icon(
              Icons.shopping_cart_outlined,
              size: 26,
            ),
            title: Text(
              'Shop',
              style: styleText(),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.payment,
              size: 26,
            ),
            title: Text(
              'Orders',
              style: styleText(),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/orders');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.edit,
              size: 26,
            ),
            title: Text(
              'Manage products',
              style: styleText(),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/user-product');
            },
          )
        ],
      ),
    );
  }
}
