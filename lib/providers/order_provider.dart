import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order.dart';

// مدیریت سفارش ها
class OrderProvider with ChangeNotifier {
  final List<OrderItem> _orders = [];

  List<OrderItem> get orders => [..._orders];

  OrderProvider() {
    loadOrders(); 
  }

// لود کردن سفارش ها
  Future<void> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('orders');

    if (data != null) {
      final List<dynamic> decoded = json.decode(data);
      _orders.clear();
      for (var item in decoded) {
        _orders.add(OrderItem(
          id: item['id'],
          amount: item['amount'],
          products: List<Map<String, dynamic>>.from(item['products']),
          dateTime: DateTime.parse(item['dateTime']),
          status: OrderStatus.values[item['status']],
          customerName: item['customerName'],
          customerUsername: item['customerUsername'],
        ));
      }
      notifyListeners();
    }
  }

  Future<void> saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> data = _orders.map((order) {
      return {
        'id': order.id,
        'amount': order.amount,
        'products': order.products,
        'dateTime': order.dateTime.toIso8601String(),
        'status': order.status.index,
        'customerName': order.customerName,
        'customerUsername': order.customerUsername,
      };
    }).toList();

    prefs.setString('orders', json.encode(data));
  }

  void addOrder({
    required List<Map<String, dynamic>> cartProducts,
    required double total,
    required String customerName,
    required String customerUsername,
  }) {
    final newOrder = OrderItem(
      id: DateTime.now().toIso8601String(),
      amount: total,
      products: cartProducts,
      dateTime: DateTime.now(),
      customerName: customerName,
      customerUsername: customerUsername,
      status: OrderStatus.pending,
    );

    _orders.insert(0, newOrder);
    saveOrders();
    notifyListeners();
  }

  void updateOrderStatus(String orderId, OrderStatus newStatus) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index >= 0) {
      _orders[index].status = newStatus;
      saveOrders();
      notifyListeners();
    }
  }

  void deleteOrder(String orderId) {
    _orders.removeWhere((o) => o.id == orderId);
    saveOrders();
    notifyListeners();
  }
}

