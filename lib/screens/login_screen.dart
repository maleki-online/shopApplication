
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/user_provider.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '', _password = '';
  bool _isLoading = false, _error = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() { _isLoading = true; _error = false; });

    final userProv = Provider.of<UserProvider>(context, listen: false);
    final success = await userProv.login(username: _username, password: _password);

    setState(() { _isLoading = false; });
    if (success) {
      // انتقال بر اساس نقش
      if (userProv.isAdmin) {
        Navigator.of(context).pushReplacementNamed('/admin');
      } else {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } else {
      setState(() { _error = true; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ورود')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_error)
                Text('نام کاربری یا رمز عبور اشتباه است',
                    style: TextStyle(color: Colors.red)),
              TextFormField(
                decoration: InputDecoration(labelText: 'نام کاربری'),
                validator: (v) => v == null || v.trim().isEmpty ? 'وارد کنید' : null,
                onSaved: (v) => _username = v!.trim(),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'رمز عبور'),
                obscureText: true,
                validator: (v) => v == null || v.trim().isEmpty ? 'وارد کنید' : null,
                onSaved: (v) => _password = v!.trim(),
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(onPressed: _submit, child: Text('ورود')),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/signup');
                },
                child: Text('ثبت‌نام نکرده‌اید؟ ثبت‌نام'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
