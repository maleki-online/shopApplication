import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'edit_profile_screen.dart';

// نمایش پروفایل یوزر
class UserProfileScreen extends StatelessWidget {
  static const routeName = '/user-profile';

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text('پروفایل کاربر')),
      body: user == null
          ? Center(child: Text('هیچ اطلاعاتی برای نمایش وجود ندارد.'))
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: user.imagePath != null && user.imagePath!.isNotEmpty
                  ? FileImage(File(user.imagePath!))
                  : AssetImage('assets/images/default_avatar.png') as ImageProvider,
            ),
            SizedBox(height: 20),
            Text('نام: ${user.name}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('ایمیل: ${user.email}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('شماره تماس: ${user.phone}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => EditProfileScreen()),
                );
              },
              child: Text('ویرایش پروفایل'),
            ),
          ],
        ),
      ),
    );
  }
}

