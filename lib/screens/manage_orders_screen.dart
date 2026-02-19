import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import '../models/order.dart';

// صفحه مدیریت سفارش ها تصاویر لود نمیشوند
class ManageOrdersScreen extends StatelessWidget {
  static const routeName = '/manage-orders';

  const ManageOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.orders;

    return Scaffold(
      appBar: AppBar(title: const Text('مدیریت سفارش‌ها')),
      body: orders.isEmpty
          ? const Center(child: Text('سفارشی ثبت نشده'))
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder: (ctx, i) {
          final order = orders[i];
          Color bgColor;
          switch (order.status) {
            case OrderStatus.approved:
              bgColor = Colors.green.shade100;
              break;
            case OrderStatus.rejected:
              bgColor = Colors.red.shade100;
              break;
            default:
              bgColor = Colors.white;
          }
          final imageAsset = order.products.isNotEmpty ? order.products[0]['imageAsset'] as String? : null;

          return Card(
            color: bgColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: ListTile(
              leading: imageAsset != null
                  ? Image.asset(
                imageAsset,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )
                  : const Icon(Icons.image),
              title: Text('سفارش: ${order.id}'),
              subtitle: Text(
                '${order.customerName} (${order.customerUsername})\n'
                    'مبلغ: ${order.amount.toInt()} تومان\n'
                    'وضعیت: ${_statusText(order.status)}',
              ),
              isThreeLine: true,
              trailing: order.status == OrderStatus.pending
                  ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () {
                      orderProvider.updateOrderStatus(order.id, OrderStatus.approved);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      orderProvider.updateOrderStatus(order.id, OrderStatus.rejected);
                    },
                  ),
                ],
              )
                  : IconButton(
                icon: const Icon(Icons.delete, color: Colors.black),
                onPressed: () {
                  orderProvider.deleteOrder(order.id);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  String _statusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.approved:
        return 'تایید شده';
      case OrderStatus.rejected:
        return 'رد شده';
      default:
        return 'در انتظار تایید';
    }
  }
}

