import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';

// دراور برای بخش کابر ادمین نمایش داده میوشد
class AdminDrawer extends StatelessWidget {
  final String currentRoute;

  AdminDrawer({required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('پنل ادمین'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('افزودن محصول'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/add-product');
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('مشاهده محصولات'),
            onTap: () {
              Navigator.of(context).pop(); 
              Navigator.of(context)
                  .pushNamed('/admin-product-list'); // باز کردن صفحه جدید
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('مدیریت دسته‌بندی‌ها'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/manage-categories');
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
            leading: const Icon(Icons.list_alt),
            title: const Text('مدیریت سفارشات'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/manage-orders');
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
            leading: const Icon(Icons.people),
            title: const Text('مدیریت کاربران'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/manage-users');
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
            leading: const Icon(Icons.logout),
            title: const Text('خروج از حساب ادمین'),
            onTap: () async {
              final userProvider = Provider.of<UserProvider>(context, listen: false);
              await userProvider.logout();
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
