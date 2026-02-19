import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// مدیریت دسته بندی ها
// مربوط به پنل ادمین
class CategoryProvider with ChangeNotifier {
  List<String> _categories = [];

  List<String> get categories => [..._categories];

  CategoryProvider() {
    loadCategories(); // هنگام ساخت، اطلاعات را بارگذاری می‌کنیم
  }

  Future<void> loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCategories = prefs.getStringList('categories');

    if (savedCategories == null || savedCategories.isEmpty) {
      _categories = ['موبایل', 'تبلت', 'هدفون']; // مقدار پیش‌فرض
      await prefs.setStringList('categories', _categories); // ذخیره اولیه
    } else {
      _categories = savedCategories;
    }
    notifyListeners();
  }

  Future<void> addCategory(String category) async {
    if (!_categories.contains(category)) {
      _categories.add(category);
      final prefs = await SharedPreferences.getInstance();
      prefs.setStringList('categories', _categories);
      notifyListeners();
    }
  }

  // حذف دسته‌بندی
  Future<void> removeCategory(String category) async {
    _categories.remove(category);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('categories', _categories);
    notifyListeners();
  }
}
