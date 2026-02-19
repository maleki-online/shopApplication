import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/products_provider.dart';
import '../../providers/category_provider.dart';

// اضافه کردن محصول در پنل ادمین
class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  String? _selectedCategory;

  void _saveForm() async {
    if (!_formKey.currentState!.validate() || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لطفاً تمام فیلدها را به درستی پر کنید')),
      );
    }

    final newProduct = Product(
      id: DateTime.now().toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      imageUrl: _imageUrlController.text.isEmpty
          ? 'assets/images/1.jpg'
          : _imageUrlController.text.trim(),
      category: _selectedCategory!,
    );

    await Provider.of<ProductProvider>(context, listen: false)
        .addProduct(newProduct);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('محصول با موفقیت اضافه شد'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<CategoryProvider>(context).categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('افزودن محصول'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'عنوان محصول'),
                validator: (value) =>
                    value!.isEmpty ? 'عنوان الزامی است' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'توضیحات'),
                maxLines: 3,
                validator: (value) =>
                    value!.isEmpty ? 'توضیحات الزامی است' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'قیمت (تومان)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'قیمت الزامی است';
                  final parsed = double.tryParse(value);
                  if (parsed == null || parsed <= 0) return 'قیمت معتبر نیست';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'آدرس تصویر'),
                validator: (value) =>
                    value!.isEmpty ? 'آدرس تصویر الزامی است' : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'دسته‌بندی'),
                items: categories.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(cat),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'انتخاب دسته‌بندی الزامی است' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.teal)),
                onPressed: _saveForm,
                child: const Text(
                  'ذخیره',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
