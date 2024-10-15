import 'dart:developer';
import 'package:firebase_testing_admin/views/product_manage.dart';
import 'package:flutter/material.dart';

import '../firebase/firebase_servicies.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  bool checkBox = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Product List "),
      ),
      body: StreamBuilder(
        stream: FirebaseServicies().getAllProduct(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error : ${snapshot.hasError}"));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final product = snapshot.data![index];

                return GestureDetector(
                  onTap: () {
                    // // Navigate to product manage screen.
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductManageScreen(
                            product:  snapshot.data![index],
                          ),
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5, top: 8),
                    child: Card(
                      shadowColor: Colors.blue,
                      elevation: 10,
                      child: ListTile(
                          leading: CircleAvatar(
                            child: Image(
                              image: NetworkImage(product.imageUrl),
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Name : ${product.name}"),
                              Text(
                                "Desc : ${product.description}",
                                maxLines: 1,
                              ),
                              Text("Price : ${product.price}"),
                              Text("Quantity : ${product.stock}"),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                  value: snapshot.data![index].inTop,
                                  //value: checkBox,
                                  onChanged: (status) async {
                                    await FirebaseServicies().updateInTopStatus(
                                        productId: snapshot.data![index].id!,
                                        status: status!);
                                  }),
                              IconButton(
                                  onPressed: () async {
                                    try {
                                      await FirebaseServicies().deleteProduct(
                                          productId: product.id!);
                                    } catch (e) {
                                      log(e.toString());
                                    }
                                  },
                                  icon: const Icon(Icons.delete)),
                            ],
                          )),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text("Product not found"),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade400,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductManageScreen(),
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
