import 'package:flutter/foundation.dart';

/// مدل مربوط به یک آیتم در سبد خرید
class CartItem {
  final String id; 
  final String title; 
  final int quantity;
  final double price;
  final String imageUrl;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'quantity': quantity,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      title: json['title'],
      quantity: json['quantity'],
      price: json['price'],
      imageUrl: json['imageUrl'],
    );
  }
}

