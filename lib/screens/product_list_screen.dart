import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductProvider>(context).items;

    return Scaffold(
      appBar: AppBar(title: const Text('لیست محصولات')),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (ctx, i) => ListTile(
          leading: Image.asset(products[i].imageUrl,fit: BoxFit.cover, width: double.infinity),
          title: Text(products[i].title),
          subtitle: Text('${products[i].price} تومان'),
          onTap: () {
            Navigator.of(context).pushNamed(
              '/product-detail',
              arguments: products[i], // باید شیء Product باشد، نه فقط ID
            );
          },
        ),
      ),
    );
  }
}
