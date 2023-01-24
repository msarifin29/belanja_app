import '../moduls/cart/widgets/cart_item.dart';

class OrderItem {
  final String? id;
  final double? amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});

  Map toJson() => {
        'id': id!,
        'amount': amount,
        'products': products,
        'dateTime': dateTime.toIso8601String(),
      };
}
