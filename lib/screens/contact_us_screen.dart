import 'package:flutter/material.dart';

/// فرم تماس با ما
class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String name = '';
    String message = '';

    return Scaffold(
      appBar: AppBar(title: const Text('تماس با ما')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'نام شما'),
                validator: (value) =>
                value!.isEmpty ? 'لطفاً نام خود را وارد کنید' : null,
                onSaved: (value) => name = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'پیام شما'),
                maxLines: 4,
                validator: (value) =>
                value!.isEmpty ? 'لطفاً پیام خود را وارد کنید' : null,
                onSaved: (value) => message = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('پیام شما ارسال شد')),
                    );
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('ارسال'),
              )
            ],
          ),
        ),
      ),
    );
  }
}