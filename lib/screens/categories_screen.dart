import 'package:FStall/screens/cart_screen.dart';
import 'package:FStall/screens/food_edit_screen.dart';
import 'package:FStall/widgets/app_drawer.dart';
import 'package:FStall/widgets/food_item_wid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  static const routeName = '/home';
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Food Menu'),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(FoodEditScreen.routeName);
              },
            ),
            IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                })
          ],
        ),
        drawer: AppDrawer(),
        body: StreamBuilder(
          stream: db.collection('food').snapshots(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final foodDocs = snapshot.data.docs;
            return foodDocs.length == 0
                ? const Center(
                    child: Text('Sorry! There are no food available.'))
                : ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: foodDocs.length,
                    itemBuilder: (ctx, index) {
                      return FoodItemWid(
                        imageUrl: foodDocs[index]['imageUrl'],
                        title: foodDocs[index]['title'],
                        id: foodDocs[index].id,
                        description: foodDocs[index]['description'],
                        price: foodDocs[index]['price'],
                      );
                    },
                  );
          },
        ),
        bottomNavigationBar: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {},
                child: Column(children: [
                  Icon(
                    Icons.shopping_bag,
                    color: Colors.green,
                    size: 32,
                  ),
                  Text(
                    "Shop",
                    style: TextStyle(fontSize: 16),
                  ),
                ]),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, CartScreen.routeName);
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      color: Colors.green,
                      size: 32,
                    ),
                    Text(
                      "Cart",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
