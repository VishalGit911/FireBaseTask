import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';

class CategoryAdd extends StatefulWidget {
  const CategoryAdd({super.key});

  @override
  State<CategoryAdd> createState() => _CategoryAddState();
}

class _CategoryAddState extends State<CategoryAdd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Category"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                final ImagePicker picker = ImagePicker();
// Pick an image.
                final XFile? image =
                    await picker.pickImage(source: ImageSource.gallery);
              },
              child: Shimmer(
                  child: CircleAvatar(
                    radius: 100,
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFEBEBF4),
                      Color(0xFFF4F4F4),
                      Color(0xFFEBEBF4),
                    ],
                    stops: [0.1, 0.3, 0.4],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: "Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, left: 15, right: 15, bottom: 50),
              child: TextFormField(
                maxLines: 4,
                decoration: InputDecoration(
                    hintText: "Description",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    fixedSize: Size(350, 60),
                    backgroundColor: Colors.green.shade800,
                    foregroundColor: Colors.white),
                onPressed: () {},
                child: Text(
                  "Save",
                  style: TextStyle(fontSize: 20),
                ))
          ],
        ),
      ),
    );
  }
}
