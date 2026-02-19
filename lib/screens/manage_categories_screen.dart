
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';

class ManageCategoriesScreen extends StatefulWidget {
  const ManageCategoriesScreen({Key? key}) : super(key: key);

  @override
  State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends State<ManageCategoriesScreen> {
  final _controller = TextEditingController();

  void _addCategory(BuildContext context) async {
    final title = _controller.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لطفاً نام دسته‌بندی را وارد کنید')),
      );
      return;
    }

    final provider = Provider.of<CategoryProvider>(context, listen: false);
    if (provider.categories.contains(title)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('این دسته‌بندی قبلاً اضافه شده است')),
      );
      return;
    }

    await provider.addCategory(title);
    _controller.clear();
  }

  void _removeCategory(BuildContext context, String category) async {
    final confirmed = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف دسته‌بندی'),
        content: Text('آیا از حذف "$category" مطمئن هستید؟'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('خیر')),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('بله')),
        ],
      ),
    );

    if (confirmed == true) {
      await Provider.of<CategoryProvider>(context, listen: false).removeCategory(category);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مدیریت دسته‌بندی‌ها'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /// فرم افزودن دسته‌بندی
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'نام دسته‌بندی جدید',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _addCategory(context),
                  child: const Text('افزودن'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            /// لیست دسته‌بندی‌ها
            Expanded(
              child: Consumer<CategoryProvider>(
                builder: (ctx, provider, _) => ListView.separated(
                  itemCount: provider.categories.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (ctx, index) {
                    final category = provider.categories[index];
                    return ListTile(
                      title: Text(category),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeCategory(context, category),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
