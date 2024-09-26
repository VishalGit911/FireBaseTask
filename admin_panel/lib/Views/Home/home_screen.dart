import 'package:admin_panel/Views/CategoryList/category_list.dart';
import 'package:admin_panel/Views/ProductList/product_list.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Grocery Admin Panel"),
          backgroundColor: Colors.green.shade800,
          foregroundColor: Colors.white,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CommonContainer(
                    color: Colors.green.shade200,
                    text: "Category",
                    image: "assets/images/category.png",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryList(),
                          ));
                    },
                  ),
                  CommonContainer(
                    color: Colors.green.shade400,
                    text: "Product",
                    image: "assets/images/product.png",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductList(),
                          ));
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CommonContainer(
                    color: Colors.green.shade400,
                    text: "Order",
                    image: 'assets/images/order.png',
                    onTap: () {},
                  ),
                  CommonContainer(
                    color: Colors.green.shade200,
                    text: "User",
                    image: "assets/images/user.png",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget CommonContainer(
      {required Color? color,
      required text,
      required String image,
      required void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 280,
        width: 170,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Image.asset(
                  image,
                  height: 60,
                ),
                radius: 50,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
