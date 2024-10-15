import 'package:firebase_testing_user/views/dashboard/shop.dart';
import 'package:flutter/material.dart';
import 'account.dart';
import 'cart.dart';
import 'favourite.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List screens = [
    const ShopScreen(),
    const FavouriteScreen(),
    const CartScreen(),
    const AccountScreen()
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.black,
        elevation: 10,
        iconSize: 30,
        selectedIconTheme: const IconThemeData(color: Colors.amber),
        unselectedIconTheme: const IconThemeData(color: Colors.black),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined), label: "Shop"),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_border), label: "Favourite"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined), label: "Cart"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined), label: "Account")
        ],
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
      ),
    );
  }
}
