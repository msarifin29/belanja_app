import 'package:belanja_app/provider/order.dart';
import 'package:belanja_app/widgets/app_drawer.dart';
import 'package:belanja_app/widgets/order_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/order.dart' show Orders;

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  static const routeName = '/orders';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isLoading = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(
      context,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Order'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (ctx, i) => OrdersItem(
                orders: orderData.orders[i],
              ),
              itemCount: orderData.orders.length,
            ),
      drawer: const AppDrawer(),
    );
  }
}
