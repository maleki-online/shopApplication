import 'package:digital_shop/models/AdsItem_model.dart';
import 'package:digital_shop/widgets/Ads.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/products_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/app_drawer.dart';
import '../../models/product.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final List<Product> products = productsProvider.items;
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('فروشگاه دیجیتال'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).pushNamed('/cart');
            },
          )
        ],
      ),
      drawer:
          AppDrawer(currentRoute: ModalRoute.of(context)?.settings.name ?? ''),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            SizedBox(
              child: AdsSlider(),
            ),
            Container(
              height: height - 100,
              width: width,
              child: products.isEmpty
                  ? const Center(child: Text('محصولی برای نمایش وجود ندارد.'))
                  : Padding(
                      padding: const EdgeInsets.all(10),
                      child: GridView.builder(
                        itemCount: products.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // دو ستون
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 4,
                          childAspectRatio: 3 / 4,
                        ),
                        itemBuilder: (ctx, index) {
                          final product = products[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                '/product-detail',
                                arguments: product,
                              );
                            },
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(12)),
                                      child: Image.asset(
                                        product.imageUrl,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.title,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                            '${product.price.toStringAsFixed(0)} تومان'),
                                        const SizedBox(height: 4),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            cartProvider.addItem(Product(
                                                id: product.id,
                                                title: product.title,
                                                description:
                                                    product.description,
                                                price: product.price,
                                                imageUrl: product.imageUrl,
                                                category: product.category));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'محصول به سبد خرید اضافه شد'),
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                              Icons.add_shopping_cart,
                                              size: 16),
                                          label: const Text('افزودن'),
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 4),
                                            textStyle:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
