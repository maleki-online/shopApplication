
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../providers/user_provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final cartItems = cart.items.values.toList();
    final cartKeys = cart.items.keys.toList();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('سبد خرید شما'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('جمع کل', style: TextStyle(fontSize: 20)),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '${cart.totalAmount.toStringAsFixed(0)} تومان',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextButton(
                    child: const Text('سفارش دادن'),
                    onPressed: () {
                      if (cartItems.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('سبد خرید خالی است!')),
                        );
                        return;
                      }

                      if (userProvider.name.isEmpty || userProvider.username.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('لطفاً ابتدا وارد حساب شوید.')),
                        );
                        return;
                      }

                      orderProvider.addOrder(
                        cartProducts: cartItems.map((item) => {
                          'id': item.id,
                          'title': item.title,
                          'price': item.price,
                          'quantity': item.quantity,
                          'imageUrl': item.imageUrl,
                        }).toList(),
                        total: cart.totalAmount,
                        customerName: userProvider.name,
                        customerUsername: userProvider.username,
                      );

                      cart.clear();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('سفارش با موفقیت ثبت شد!')),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (ctx, i) => ListTile(
                leading: CircleAvatar(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: FittedBox(
                      child: Text('${cartItems[i].price.toInt()} تومان'),
                    ),
                  ),
                ),
                title: Text(cartItems[i].title),
                subtitle: Text('تعداد: ${cartItems[i].quantity}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    cart.removeItem(cartKeys[i]);
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
