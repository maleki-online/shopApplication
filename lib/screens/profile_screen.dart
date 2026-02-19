import 'package:flutter/material.dart';

//  صفحه پروفایل کاربر تست
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('پروفایل')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/images/user.png'), 
            ),
            SizedBox(height: 10),
            Text('نام: علی رضایی'),
            Text('ایمیل: ali@example.com'),
            Text('شماره تماس: 09123456789'),
            SizedBox(height: 20),
            Text('نقش: مدیر سیستم', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}