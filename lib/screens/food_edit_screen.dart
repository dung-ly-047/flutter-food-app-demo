import 'package:FStall/widgets/add_food_modal.dart';
import 'package:FStall/widgets/food_editing_wid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FoodEditScreen extends StatefulWidget {
  static const routeName = '/edit-food';
  @override
  _FoodEditScreenState createState() => _FoodEditScreenState();
}

class _FoodEditScreenState extends State<FoodEditScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            title: Text('Edit Food'),
            actions: [
              IconButton(
                icon: Icon(Icons.check),
                onPressed: null,
              ),
            ],
          ),
          body: FutureBuilder(
            future: FirebaseFirestore.instance.collection('food').get(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final foodDocs = snapshot.data.docs;
              return foodDocs.length == 0
                  ? Center(
                      child: Text('No food added.'),
                    )
                  : ListView.builder(
                      itemCount: foodDocs.length,
                      itemBuilder: (ctx, index) => FoodEditingWid(
                        imageUrl: foodDocs[index]['imageUrl'],
                        title: foodDocs[index]['title'],
                        price: foodDocs[index]['price'],
                      ),
                    );
            },
          ),
          floatingActionButton: MaterialButton(
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (_) {
                  return AddFoodModal();
                },
              );
            },
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.all(10),
            shape: CircleBorder(),
            child: Icon(
              Icons.add,
            ),
          )),
    );
  }
}
