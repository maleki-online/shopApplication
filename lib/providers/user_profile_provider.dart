import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// این کلاس باید حذف شود
class UserProvider2 with ChangeNotifier {
  String _name = '';
  String _email = '';
  String _phone = '';
  String _imagePath = '';
  bool _isAdmin = false;

  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get imagePath => _imagePath;
  bool get isAdmin => _isAdmin;

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('user_name') ?? '';
    _email = prefs.getString('user_email') ?? '';
    _phone = prefs.getString('user_phone') ?? '';
    _imagePath = prefs.getString('user_image') ?? '';
    _isAdmin = prefs.getBool('user_is_admin') ?? false;
    notifyListeners();
  }

  Future<void> updateUser({
    required String name,
    required String email,
    required String phone,
    String? imagePath,
    required bool isAdmin,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    _name = name;
    _email = email;
    _phone = phone;
    _imagePath = imagePath ?? _imagePath;
    _isAdmin = isAdmin;

    await prefs.setString('user_name', _name);
    await prefs.setString('user_email', _email);
    await prefs.setString('user_phone', _phone);
    await prefs.setString('user_image', _imagePath);
    await prefs.setBool('user_is_admin', _isAdmin);

    notifyListeners();
  }
}



