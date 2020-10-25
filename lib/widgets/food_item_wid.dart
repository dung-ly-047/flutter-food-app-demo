import 'package:FStall/screens/food_detail_screen.dart';
import 'package:flutter/material.dart';

class FoodItemWid extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String id;
  final String description;
  final double price;

  FoodItemWid(
      {this.title, this.imageUrl, this.id, this.description, this.price});

  void _onSelect(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      FoodDetailScreen.routeName,
      arguments: {
        'title': title,
        'imageUrl': imageUrl,
        'id': id,
        'price': price,
        'description': description,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onSelect(context),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Hero(
                tag: id,
                child: Image.network(
                  imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black54,
                ),
                child: FittedBox(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
