import 'package:belanja_app/moduls/order/view_model/order.dart';
import 'package:belanja_app/utils/common_widgets/app_drawer.dart';
import 'package:belanja_app/moduls/order/widgets/order_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/order.dart' show Orders;

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  static const routeName = '/orders';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  // ignore: prefer_typing_uninitialized_variables, unused_field
  var _ordersFuture;

  // ignore: unused_element
  Future _obtainOrdersFuture() async {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
    // return context.read<Orders>().fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(
    //   context,
    // );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Order'),
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Text('Terjadi kesalahan!');
          }
          return Consumer<Orders>(
            builder: (context, orderData, child) => ListView.builder(
              itemBuilder: (ctx, i) => OrdersItem(
                orders: orderData.orders[i],
              ),
              itemCount: orderData.orders.length,
            ),
          );
        },
        future: _obtainOrdersFuture(),
      ),
      drawer: const AppDrawer(),
    );
  }
}
