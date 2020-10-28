import 'package:FStall/screens/cart_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FoodDetailScreen extends StatelessWidget {
  static const routeName = '/details';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as Map;

    CollectionReference userCart = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('cart');

    return Scaffold(
      appBar: AppBar(
        title: Text(args['title']),
        actions: [
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          )
        ],
      ),
      body: Builder(
        builder: (context) => Column(
          children: [
            Hero(
              tag: args['id'],
              child: Image.network(
                args['imageUrl'],
                fit: BoxFit.cover,
                height: 400,
                width: double.infinity,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '\$${args['price'].toString()}',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(args['description']),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: RaisedButton(
        child: Text('Add to cart'),
        onPressed: () {
          final cartAddedItem = userCart.doc(args['id']);
          cartAddedItem.get().then((value) {
            if (value.exists) {
              cartAddedItem.update({
                'quantity': value.get('quantity') + 1,
              });
            } else {
              cartAddedItem.set({
                'title': args['title'],
                'quantity': 1,
                'price': args['price']
              });
            }
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
