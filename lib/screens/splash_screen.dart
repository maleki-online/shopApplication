
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/order_provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);

// لود کردن سفارش ها و یوزر ها در اسپلش اسکرین
      await userProvider.loadUserData();
      await orderProvider.loadOrders();

      if (!mounted) return;

      // ریدایرکت براساس نوع کاربر
      if (userProvider.isLoggedIn) {
        Navigator.of(context).pushReplacementNamed(
          userProvider.isAdmin ? '/admin' : '/home',
        );
      } else {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e) {
      print('خطا در مقداردهی اولیه: $e');
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade100,
      body: Center(
        child: _isLoading
            ? Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/app_icon.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(color: Colors.teal),
            const SizedBox(height: 10),
            const Text(
              'در حال بارگذاری اطلاعات...',
              style: TextStyle(fontSize: 16),
            ),
          ],
        )
            : const SizedBox(), // به ندرت اجرا میشه، چون بعد از ریدایرکت خالی می‌مونه
      ),
    );
  }
}
