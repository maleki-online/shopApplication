enum OrderStatus { pending, approved, rejected }

// ایتم های سفارش
class OrderItem {
  final String id;
  final double amount;
  final List<Map<String, dynamic>> products;
  final DateTime dateTime;
  OrderStatus status;
  final String customerName;
  final String customerUsername;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
    this.status = OrderStatus.pending,
    required this.customerName,
    required this.customerUsername,
  });

}
