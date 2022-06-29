import 'package:belanja_app/provider/order.dart';
import 'package:belanja_app/widgets/app_drawer.dart';
import 'package:belanja_app/widgets/order_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/order.dart' show Orders;

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(
      context,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Order'),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, i) => OrdersItem(
          orders: orderData.orders[i],
        ),
        itemCount: orderData.orders.length,
      ),
      drawer: const AppDrawer(),
    );
  }
}
