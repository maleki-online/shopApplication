import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

// کارت های مربوط به مدیریت محصولات در سبد خرید
class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, item) {
      total += item.price * item.quantity;
    });
    return total;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
            (existing) => CartItem(
          id: existing.id,
          title: existing.title,
          price: existing.price,
          quantity: existing.quantity + 1,
          imageUrl: existing.imageUrl,
        ),
      );
    } else {
      _items[product.id] = CartItem(
        id: DateTime.now().toString(),
        title: product.title,
        price: product.price,
        quantity: 1,
        imageUrl: product.imageUrl,
      );
    }
    _saveToPrefs();
    notifyListeners();
  }

  /// حذف یک محصول از سبد
  void removeItem(String productId) {
    _items.remove(productId);
    _saveToPrefs();
    notifyListeners();
  }

  /// پاک کردن کل سبد
  void clear() {
    _items.clear();
    _saveToPrefs();
    notifyListeners();
  }

  /// ذخیره‌سازی در SharedPreferences
  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = _items.map((key, value) => MapEntry(key, value.toJson()));
    prefs.setString('cart_items', jsonEncode(cartData));
  }

  /// بارگذاری از SharedPreferences
  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('cart_items')) return;

    final extractedData = jsonDecode(prefs.getString('cart_items')!) as Map<String, dynamic>;
    _items.clear();
    extractedData.forEach((key, value) {
      _items[key] = CartItem.fromJson(value);
    });
    notifyListeners();
  }
}
