import 'dart:developer';
import 'package:flutter/material.dart';
import '../../Firebase/firebase_services.dart';
import '../CategoryAdd/category_add.dart';


class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Category List Screen"),
        backgroundColor: Colors.amber.shade400,
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: StreamBuilder(
          stream: FirebaseServicies().getCategory(),

          /*
          [
          CategoryModel(categoryName:"vegetables",categoryDescription : "category desc",categoryId:"8dsf8sdf8fs9d")
          ]
           */
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.hasError.toString()),
              );
            } else if (snapshot.hasData) {
              log("snapshot.hasData : ${snapshot.hasData}");

              log("Snapshot data : ${snapshot.data}");
              // print("Snapshot.data[0] : ${snapshot.data![0].name}");
              // print("Snapshot.data[0] : ${snapshot.data![0].description}");

              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final value = snapshot.data![index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
// print("Yes you can update category...");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryManageScreen(
                                categoryModel: snapshot.data![index],
                              ),
                            ));
                      },
                      child: Card(
                        elevation: 10,
                        shadowColor: Colors.yellow,
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                            NetworkImage(value.imageUrl) as ImageProvider,
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                value.name,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w400),
                              ),
                              Text(
                                value.description,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                // call function for delete category.

                                FirebaseServicies()
                                    .removeCategory(categoryId: value.id!);
                              },
                              icon: const Icon(Icons.delete)),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text("Category Not Found"),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryManageScreen(),
              ));
        },
        backgroundColor: Colors.amber.shade400,
        child: const Icon(Icons.add),
      ),
    );
  }
}
