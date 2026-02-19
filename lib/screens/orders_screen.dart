
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order.dart';
import '../providers/order_provider.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  const OrdersScreen({super.key});

  String getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.approved:
        return 'تایید شده';
      case OrderStatus.rejected:
        return 'رد شده';
      case OrderStatus.pending:
      default:
        return 'در حال بررسی';
    }
  }

  Color getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.approved:
        return Colors.green[100]!;
      case OrderStatus.rejected:
        return Colors.red[100]!;
      case OrderStatus.pending:
      default:
        return Colors.grey[200]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrderProvider>(context);
    final orders = orderData.orders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('سفارش‌های من'),
      ),
      body: orders.isEmpty
          ? const Center(child: Text('سفارشی ثبت نشده است'))
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder: (ctx, i) {
          final order = orders[i];
          return Card(
            color: getStatusColor(order.status),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: ExpansionTile(
              title: Text(
                'سفارش ${order.id}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${order.amount.toInt()} تومان - ${getStatusText(order.status)}\n'
                    '${DateFormat('yyyy/MM/dd – HH:mm').format(order.dateTime)}',
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'کاربر: ${order.customerName} (${order.customerUsername})',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      const Text('محصولات سفارش داده شده:'),
                      const SizedBox(height: 5),
                      ...order.products.map((product) {
                        return ListTile(
                          leading: product['imagePath'] != null
                              ? Image.asset(
                            product['imagePath'],
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          )
                              : const Icon(Icons.image),
                          title: Text(product['title']),
                          subtitle: Text('${product['price'].toInt()} تومان'),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

