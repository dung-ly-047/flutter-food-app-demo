import 'package:flutter/material.dart';

class FoodItem {
  final String title;
  final String description;
  final String imageUrl;
  final double price;

  FoodItem({
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    @required this.title,
  });
}
