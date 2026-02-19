import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

/// مدیریت لیست محصولات
class ProductProvider with ChangeNotifier {
  List<Product> _items = [];

  // لیست محصولات تست
  // final List<Product> _items = [
  //   Product(
  //     id: 'p1',
  //     title: 'گوشی سامسونگ A54',
  //     description: 'گوشی هوشمند با صفحه‌نمایش Super AMOLED و دوربین ۵۰ مگاپیکسلی',
  //     price: 14990000,
  //     imageUrl: 'assets/images/1.jpg',
  //     category: 'موبایل',
  //   ),
  //   Product(
  //     id: 'p2',
  //     title: 'هدفون بی‌سیم JBL',
  //     description: 'هدفون بلوتوثی با کیفیت صدای بالا و باتری قوی',
  //     price: 2290000,
  //     imageUrl: 'assets/images/2.jpg',
  //     category: 'هدفون',
  //   ),
  //   Product(
  //     id: 'p3',
  //     title: 'هدفون بی‌سیم JBL',
  //     description: 'هدفون بلوتوثی با کیفیت صدای بالا و باتری قوی',
  //     price: 2290000,
  //     imageUrl: 'assets/images/3.png',
  //     category: 'هدفون',
  //   ),
  //   Product(
  //     id: 'p4',
  //     title: 'هدفون بی‌سیم JBL',
  //     description: 'هدفون بلوتوثی با کیفیت صدای بالا و باتری قوی',
  //     price: 2290000,
  //     imageUrl: 'assets/images/4.png',
  //     category: 'هدفون',
  //   ),
  //   Product(
  //     id: 'p5',
  //     title: 'هدفون بی‌سیم JBL',
  //     description: 'هدفون بلوتوثی با کیفیت صدای بالا و باتری قوی',
  //     price: 2290000,
  //     imageUrl: 'assets/images/1.jpg',
  //     category: 'هدفون',
  //   ),
  //   Product(
  //     id: 'p6',
  //     title: 'هدفون بی‌سیم JBL',
  //     description: 'هدفون بلوتوثی با کیفیت صدای بالا و باتری قوی',
  //     price: 2290000,
  //     imageUrl: 'assets/images/2.jpg',
  //     category: 'هدفون',
  //   ),
  //   Product(
  //     id: 'p7',
  //     title: 'هدفون بی‌سیم JBL',
  //     description: 'هدفون بلوتوثی با کیفیت صدای بالا و باتری قوی',
  //     price: 2290000,
  //     imageUrl: 'assets/images/3.png',
  //     category: 'هدفون',
  //   ),
  //   Product(
  //     id: 'p8',
  //     title: 'هدفون بی‌سیم JBL',
  //     description: 'هدفون بلوتوثی با کیفیت صدای بالا و باتری قوی',
  //     price: 2290000,
  //     imageUrl: 'assets/images/4.png',
  //     category: 'هدفون',
  //   ),
  //   Product(
  //     id: 'p9',
  //     title: 'هدفون بی‌سیم JBL',
  //     description: 'هدفون بلوتوثی با کیفیت صدای بالا و باتری قوی',
  //     price: 2290000,
  //     imageUrl: 'assets/images/3.png',
  //     category: 'هدفون',
  //   ),
  //   Product(
  //     id: 'p10',
  //     title: 'هدفون بی‌سیم JBL',
  //     description: 'هدفون بلوتوثی با کیفیت صدای بالا و باتری قوی',
  //     price: 2290000,
  //     imageUrl: 'assets/images/1.jpg',
  //     category: 'هدفون',
  //   ),
  //   Product(
  //     id: 'p11',
  //     title: 'هدفون بی‌سیم JBL',
  //     description: 'هدفون بلوتوثی با کیفیت صدای بالا و باتری قوی',
  //     price: 2290000,
  //     imageUrl: 'assets/images/2.jpg',
  //     category: 'هدفون',
  //   ),
  //   Product(
  //     id: 'p12',
  //     title: 'هدفون بی‌سیم JBL',
  //     description: 'هدفون بلوتوثی با کیفیت صدای بالا و باتری قوی',
  //     price: 2290000,
  //     imageUrl: 'assets/images/4.png',
  //     category: 'هدفون',
  //   ),
  //   // می‌تونی محصولات بیشتری اضافه کنی
  // ];

  List<Product> get items => [..._items]; // کپی از لیست

  ProductsProvider() {
    loadProducts();
  }
  // بارگذاری محصولات از حافظه دائمی
  Future<void> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('products');
    if (data != null) {
      final decoded = json.decode(data) as List<dynamic>;
      _items = (decoded as List)
          .map((item) => Product.fromJson(Map<String, dynamic>.from(item)))
          .toList();
      notifyListeners();
    }
  }
  // ذخیره کردن کل محصولات در حافظه دائمی
  Future<void> _saveProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productsData  = json.encode(_items.map((product) => product.toJson()).toList());
    await prefs.setString('products', productsData );
  }

  // افزودن محصول جدید
  Future<void> addProduct(Product product) async {
    _items.add(product);
    notifyListeners();
    await _saveProducts();
  }

  // برای ویرایش محصول
  Future<void> updateProduct(String id, Product newProduct) async {
    final index = _items.indexWhere((product) => product.id == id);
    if (index >= 0) {
      _items[index] = newProduct;
      notifyListeners();
      await _saveProducts();
    }
    else {
      throw Exception('محصولی با شناسه $id یافت نشد');
    }
  }

  Future<void> deleteProduct(String id) async {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
    await _saveProducts(); // ذخیره دائمی
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }
}
