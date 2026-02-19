import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/products_provider.dart';
import '../../providers/category_provider.dart';

// مدیریت محصولات در پنل ادمین 
class EditProductScreen extends StatefulWidget {
  final String productId;

  const EditProductScreen({Key? key, required this.productId})
      : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _imageUrlController;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    final product = Provider.of<ProductProvider>(context, listen: false)
        .findById(widget.productId);
    _titleController = TextEditingController(text: product.title);
    _descriptionController = TextEditingController(text: product.description);
    _priceController = TextEditingController(text: product.price.toString());
    _imageUrlController = TextEditingController(text: product.imageUrl);
    _selectedCategory = product.category;
  }

  void _saveForm() async {
    if (!_formKey.currentState!.validate() || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لطفاً تمام فیلدها را به درستی پر کنید')),
      );
      return;
    }

    final updatedProduct = Product(
      id: widget.productId,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      imageUrl: _imageUrlController.text.trim(),
      category: _selectedCategory!,
    );

    await Provider.of<ProductProvider>(context, listen: false)
        .updateProduct(widget.productId, updatedProduct);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('تغییرات محصول با موفقیت ذخیره شد'),
          backgroundColor: Colors.green),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<CategoryProvider>(context).categories;

    return Scaffold(
      appBar: AppBar(title: const Text('ویرایش محصول')),
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
                decoration: const InputDecoration(labelText: 'قیمت'),
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
                    value == null ? 'دسته‌بندی را انتخاب کنید' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: const Text('ذخیره تغییرات'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
