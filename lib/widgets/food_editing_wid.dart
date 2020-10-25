import 'package:flutter/material.dart';

class FoodEditingWid extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double price;

  FoodEditingWid({this.title, this.price, this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              height: 100,
              width: 100,
            ),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '\$${price.toString()}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
