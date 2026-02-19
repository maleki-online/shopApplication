
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(product.imageUrl,fit: BoxFit.cover, width: double.infinity),
            const SizedBox(height: 10),
            Text(product.title, style: Theme.of(context).textTheme.titleLarge),
            Text('${product.price} تومان'),
            const SizedBox(height: 20),
            Text(product.description),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                cart.addItem(
                    Product(
                        id: product.id,
                        title: product.title,
                        description: product.description,
                        price: product.price,
                        imageUrl: product.imageUrl,
                        category: product.category)
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('به سبد خرید افزوده شد')),
                );
              },
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('افزودن به سبد خرید'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            )
          ],
        ),
      ),
    );
  }
}

