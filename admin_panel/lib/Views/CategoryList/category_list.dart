import 'package:admin_panel/Firebase/firebase_services.dart';
import 'package:admin_panel/Views/CategoryAdd/category_add.dart';
import 'package:flutter/material.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Category"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryAdd(),
              ));
        },
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: StreamBuilder(
          stream: FirebaseServices().getcategory(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.green.shade800,
                ),
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final value = snapshot.data![index];

                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryAdd(
                                categoryModel: snapshot.data![index],
                              ),
                            ));
                      },
                      child: Card(
                        shadowColor: Colors.black,
                        elevation: 5,
                        child: ListTile(
                          title: Text(value.name),
                          subtitle: Text(value.description),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(value.imageUrl),
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                FirebaseServices().categorydelet(
                                    categoryid: value.id.toString());
                              },
                              icon: Icon(Icons.delete)),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Container(),
              );
            }
          },
        ),
      ),
    );
  }
}
