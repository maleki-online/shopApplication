import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup';
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '', _password = '', _name = '', _email = '', _phone = '';
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    await Provider.of<UserProvider>(context, listen: false).signup(
      username: _username,
      password: _password,
      name: _name,
      email: _email,
      phone: _phone,
    );
    setState(() => _isLoading = false);

    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ثبت‌نام')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'نام و نام خانوادگی'),
                validator: (v) => v == null || v.trim().isEmpty ? 'وارد کنید' : null,
                onSaved: (v) => _name = v!.trim(),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'ایمیل'),
                validator: (v) => v == null || !v.contains('@') ? 'ایمیل معتبر' : null,
                onSaved: (v) => _email = v!.trim(),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'شماره تماس'),
                validator: (v) => v == null || v.trim().length < 8 ? 'شماره صحیح' : null,
                onSaved: (v) => _phone = v!.trim(),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'نام کاربری'),
                validator: (v) => v == null || v.trim().isEmpty ? 'وارد کنید' : null,
                onSaved: (v) => _username = v!.trim(),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'رمز عبور'),
                obscureText: true,
                validator: (v) => v == null || v.trim().length < 6 ? 'حداقل ۶ کاراکتر' : null,
                onSaved: (v) => _password = v!.trim(),
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(onPressed: _submit, child: Text('ثبت‌نام')),
            ],
          ),
        ),
      ),
    );
  }
}
