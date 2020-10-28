import 'package:FStall/widgets/cart_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CollectionReference userCart = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection('cart');

  double _totalPrice = 0.0;

  Future<void> _mathHandler() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('cart')
        .get()
        .then((snapshot) {
      double totalPrice = 0.0;
      snapshot.docs.forEach((element) {
        totalPrice += element['price'] * element['quantity'];
      });
      print(totalPrice);
      setState(() {
        _totalPrice = totalPrice;
      });
    });
  }

  @override
  void didChangeDependencies() {
    _mathHandler();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: RefreshIndicator(
        onRefresh: _mathHandler,
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.all(15),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Spacer(),
                    Chip(
                      label: Text(
                        '\$$_totalPrice',
                        style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline1
                              .color,
                        ),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    FlatButton(
                      textColor: Colors.blue,
                      onPressed: () {},
                      child: Text('Order Now'),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: FutureBuilder(
                future: userCart.get(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final cartItemDocs = snapshot.data.docs;

                  return cartItemDocs.length == 0
                      ? Center(
                          child: Text('Your card is empty.'),
                        )
                      : ListView.builder(
                          itemCount: cartItemDocs.length,
                          itemBuilder: (ctx, index) => CartItem(
                            id: cartItemDocs[index].id,
                            price: cartItemDocs[index]['price'],
                            quantity: cartItemDocs[index]['quantity'],
                            title: cartItemDocs[index]['title'],
                          ),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
