import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../screens/user_profile_screen.dart';
import '../models/user.dart';

// دراور برای بخش کابر ادمین نمایش داده میوشد
class AppDrawer extends StatelessWidget {
  final String currentRoute;

  AppDrawer({required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.currentUser;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: user != null && user.imagePath != null && user.imagePath!.isNotEmpty
                  ? FileImage(File(user.imagePath!))
                  : AssetImage('assets/images/default_avatar.png') as ImageProvider,
            ),
            accountName: Text(user?.name ?? 'بدون نام'),
            accountEmail: Text(user?.role == UserRole.admin ? 'ادمین' : 'کاربر معمولی'),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('پروفایل کاربر'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => UserProfileScreen()),
              );
            },
          ),
          Divider(
            height: 20,
            thickness: 1,
            color: Colors.grey.shade400,
            indent: 10,
            endIndent: 10,
          ),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('فروشگاه'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('سبد خرید'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/cart');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('خروج از حساب کاربری'),
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('خروج از حساب'),
                  content: Text('آیا مطمئن هستید که می‌خواهید خارج شوید؟'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: Text('خیر'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: Text('بله'),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                await userProvider.logout();
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
              }
            },
          ),
        ],
      ),
    );
  }
}
