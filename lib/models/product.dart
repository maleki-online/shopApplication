import 'package:flutter/foundation.dart';

/// مدل مربوط به یک محصول دیجیتال
class Product {
  final String id; // شناسه یکتا برای هر محصول
  final String title; // عنوان محصول (مثلاً "گوشی سامسونگ")
  final String description; // توضیحات محصول
  final double price; // قیمت محصول
  final String imageUrl; // لینک تصویر محصول
  final String category; // دسته‌بندی (مثلاً "موبایل", "هدفون")

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    price: json['price'],
    imageUrl: json['imageUrl'],
    category: json['category'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'price': price,
    'imageUrl': imageUrl,
    'category' : category,
  };

  Product copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
    );
  }
}
