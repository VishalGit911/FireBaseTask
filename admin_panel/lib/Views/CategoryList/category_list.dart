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
    );
  }
}
