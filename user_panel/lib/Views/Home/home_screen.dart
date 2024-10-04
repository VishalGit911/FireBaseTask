import 'package:flutter/material.dart';
import 'package:user_panel/Views/Home/Dashboard/account_screen.dart';
import 'package:user_panel/Views/Home/Dashboard/cart_screen.dart';
import 'package:user_panel/Views/Home/Dashboard/favorite_screen.dart';
import 'package:user_panel/Views/Home/Dashboard/shop_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  List screenList = [
    ShopScreen(),
    CartScreen(),
    FavoriteScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screenList[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          currentIndex: currentIndex,
          selectedItemColor: Colors.green.shade800,
          unselectedItemColor: Colors.grey,
          selectedIconTheme: IconThemeData(size: 30),
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_outlined), label: "Shop"),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined), label: "Cart"),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border), label: "Favorite"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
          ]),
    );
  }
}
