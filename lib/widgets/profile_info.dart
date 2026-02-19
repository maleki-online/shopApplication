import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';

// نمایش اطلاعات کاربر
class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).currentUser;

    return user == null
        ? const Center(child: Text('ورود انجام نشده'))
        : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('نام: ${user.name}', style: Theme.of(context).textTheme.titleLarge),
        Text('ایمیل: ${user.email}'),
        Text('نقش: ${user.role == UserRole.admin ? 'مدیر' : 'کاربر'}'),
      ],
    );
  }
}
