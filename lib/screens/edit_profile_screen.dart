import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  final _currentPassController = TextEditingController();
  final _newPassController = TextEditingController();

  File? _image;
  bool _imageRemoved = false;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false);
    _nameController = TextEditingController(text: user.name);
    _emailController = TextEditingController(text: user.email);
    _phoneController = TextEditingController(text: user.phone);
    if (user.imagePath.isNotEmpty) {
      _image = File(user.imagePath);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
        _imageRemoved = false;
      });
    }
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;

    final user = Provider.of<UserProvider>(context, listen: false);
    await user.updateUser(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      imagePath: _imageRemoved ? '' : _image?.path,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تغییرات با موفقیت ذخیره شد'), backgroundColor: Colors.green,),
    );
    Navigator.of(context).pop();
  }

  Future<void> _changePassword() async {
    if (!_passwordFormKey.currentState!.validate()) return;
    final user = Provider.of<UserProvider>(context, listen: false);
    final result = await user.changePassword(
      _currentPassController.text.trim(),
      _newPassController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result ? 'رمز عبور تغییر یافت' : 'رمز فعلی اشتباه است')),
    );
    if (result) {
      _currentPassController.clear();
      _newPassController.clear();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _currentPassController.dispose();
    _newPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('ویرایش پروفایل')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // تصویر پروفایل
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    child: ClipOval(
                      child: _image != null
                          ? Image.file(_image!, width: 120, height: 120, fit: BoxFit.cover)
                          : Image.asset('assets/images/default_avatar.png',
                          width: 120, height: 120, fit: BoxFit.cover),
                    ),
                  ),
                  if (_image != null)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _image = null;
                            _imageRemoved = true;
                          });
                        },
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.red,
                          child: Icon(Icons.close, size: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.green,
                        child: Icon(Icons.edit, size: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // فرم اطلاعات کاربری
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'نام'),
                    validator: (value) =>
                    value == null || value.isEmpty ? 'نام را وارد کنید' : null,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'ایمیل'),
                    validator: (value) =>
                    value != null && value.contains('@') ? null : 'ایمیل معتبر وارد کنید',
                  ),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: 'شماره تماس'),
                    keyboardType: TextInputType.phone,
                    validator: (value) =>
                    value != null && value.length >= 8 ? null : 'شماره صحیح وارد کنید',
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveForm,
                    child: Text('ذخیره تغییرات'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            Divider(thickness: 1),
            const SizedBox(height: 10),
            Text(
              'تغییر رمز عبور',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            // فرم تغییر رمز
            Form(
              key: _passwordFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _currentPassController,
                    decoration: InputDecoration(labelText: 'رمز فعلی'),
                    obscureText: true,
                    validator: (value) =>
                    value == null || value.isEmpty ? 'رمز فعلی را وارد کنید' : null,
                  ),
                  TextFormField(
                    controller: _newPassController,
                    decoration: InputDecoration(labelText: 'رمز جدید'),
                    obscureText: true,
                    validator: (value) =>
                    value != null && value.length >= 6 ? null : 'حداقل ۶ کاراکتر',
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _changePassword,
                    child: Text('تغییر رمز عبور'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

