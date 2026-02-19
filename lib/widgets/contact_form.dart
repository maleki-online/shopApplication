import 'package:flutter/material.dart';

// فرم مربوط به ارتباط با ما 
class ContactForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  ContactForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'نام شما'),
            validator: (value) =>
            value!.isEmpty ? 'نام را وارد کنید' : null,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'ایمیل'),
            validator: (value) =>
            value!.isEmpty ? 'ایمیل را وارد کنید' : null,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'پیام شما'),
            maxLines: 4,
            validator: (value) =>
            value!.isEmpty ? 'پیام را وارد کنید' : null,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // ارسال فرم
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('پیام ارسال شد')),
                );
              }
            },
            child: const Text('ارسال'),
          ),
        ],
      ),
    );
  }
}
