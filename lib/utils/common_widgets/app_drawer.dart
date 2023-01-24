import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../moduls/auth/view_model/auth.dart';

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
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.exit_to_app_outlined,
              size: 26,
            ),
            title: Text(
              'Log Out',
              style: styleText(),
            ),
            onTap: () {
              Navigator.pop(context);
              Provider.of<Auth>(context, listen: false).logOut();
              // context.read<Auth>().logOut();
            },
          ),
        ],
      ),
    );
  }
}
