import 'package:firebase_testing_admin/firebase/firebase_servicies.dart';
import 'package:firebase_testing_admin/views/category_list.dart';
import 'package:firebase_testing_admin/views/login.dart';
import 'package:firebase_testing_admin/views/product_list.dart';
import 'package:firebase_testing_admin/views/user.dart';
import 'package:flutter/material.dart';

import 'orderlist.dart';

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
          title: const Text("Dashboard"),
          actions: [
            IconButton(
              onPressed: () async {
                await FirebaseServicies().signOutAdmin();

                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseServicies().fetchDashboardData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {

              final dashboardData  = snapshot.data;

              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1 / 1.3,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CategoryListScreen(),
                            ),
                          );
                        },
                        child: _dashboardCard(
                            title: 'Categories',
                            value: dashboardData!.totalCategories,
                            color: Colors.amber.shade400,
                            image: "assets/images/categories.png"),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProductListScreen(),
                              ));
                        },
                        child: _dashboardCard(
                            title: 'Products',
                            value: dashboardData.totalProduct,
                            color: Colors.blue.shade400,
                            image: "assets/images/product.png"),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UserScreen(),
                              ));
                        },
                        child: _dashboardCard(
                          title: 'User',
                          value: dashboardData.totalUsers,
                          image: "assets/images/users.png",
                          color: Colors.pinkAccent.shade400,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const OrderListScreen(),
                              ));
                        },
                        child: _dashboardCard(
                          title: "order",
                          color: Colors.purple.shade400,
                          image: "assets/images/order.png",
                          value: dashboardData.totalOrders,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ));
  }

  Widget _dashboardCard(
      {required String title,
      required int value,
      required Color color,
      required String image}) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 45,
                backgroundColor: Colors.white.withOpacity(.4),
                child: Image.asset(
                  image,
                  height: 43,
                  width: 43,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                '$value',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 30),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 23),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
