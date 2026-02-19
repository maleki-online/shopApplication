import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

//  مدیریت کابران در پنل ادمین
class ManageUsersScreen extends StatelessWidget {
  static const routeName = '/manage-users';

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final allUsers = userProvider.allUsers;

    return Scaffold(
      appBar: AppBar(title: Text('مدیریت کاربران')),
      body: allUsers.isEmpty
          ? Center(child: Text('هیچ کاربری وجود ندارد'))
          : ListView.builder(
        itemCount: allUsers.length,
        itemBuilder: (ctx, i) {
          final user = allUsers[i];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: user.imagePath.isNotEmpty
                  ? CircleAvatar(
                backgroundImage: FileImage(File(user.imagePath)),
              )
                  : CircleAvatar(child: Icon(Icons.person)),
              title: Text(user.name),
              subtitle: Text('نام کاربری: ${user.username}\nایمیل: ${user.email}'),
              trailing: user.username == 'admin'
                  ? null
                  : IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: (){
                   _showDeleteDialog(context, userProvider, user.username);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, UserProvider provider, String username)  {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('حذف کاربر؟'),
        content: Text('آیا مطمئن هستید که می‌خواهید کاربر را حذف کنید؟'),
        actions: [
          TextButton(
            child: Text('خیر'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text('بله، حذف'),
            onPressed: () async {
              await provider.deleteUser(username); // حذف اطلاعات فعلی
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('کاربر حذف شد')),
              );
            },
          ),
        ],
      ),
    );
  }
}
