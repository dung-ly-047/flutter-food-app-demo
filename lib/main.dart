import 'package:FStall/screens/auth_screen.dart';
import 'package:FStall/screens/cart_screen.dart';
import 'package:FStall/screens/categories_screen.dart';
import 'package:FStall/screens/food_detail_screen.dart';
import 'package:FStall/screens/food_edit_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Stall',
      theme: ThemeData(
        primarySwatch: Colors.lime,
        accentColor: Colors.blue,
        fontFamily: 'Grandstander',
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LinearProgressIndicator(),
            );
          }
          if (userSnapshot.hasData) {
            return CategoriesScreen();
          }
          return AuthScreen();
        },
      ),
      routes: {
        FoodEditScreen.routeName: (ctx) => FoodEditScreen(),
        FoodDetailScreen.routeName: (ctx) => FoodDetailScreen(),
        CartScreen.routeName: (ctx) => CartScreen(),
      },
    );
  }
}
