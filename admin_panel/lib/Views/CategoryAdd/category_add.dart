import 'dart:io';

import 'package:admin_panel/Firebase/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CategoryAdd extends StatefulWidget {
  const CategoryAdd({super.key});

  @override
  State<CategoryAdd> createState() => _CategoryAddState();
}

class _CategoryAddState extends State<CategoryAdd> {
  XFile? newimage;
  TextEditingController categorynamecontroller = TextEditingController();
  TextEditingController categorydescriptioncontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Category"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Select Image Source"),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              ListTile(
                                leading: const Icon(Icons.camera),
                                title: const Text("Camera"),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  pickImage(source: ImageSource.camera);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.photo_library),
                                title: const Text("Gallery"),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  pickImage(source: ImageSource.gallery);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: CircleAvatar(
                  backgroundColor: Colors.green.shade200,
                  backgroundImage: newimage != null
                      ? FileImage(File(newimage!.path))
                      : NetworkImage(
                              "https://www.freeiconspng.com/thumbs/add-icon-png/add-icon--endless-icons-21.png")
                          as ImageProvider,
                  radius: 100,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
                child: TextFormField(
                  controller: categorynamecontroller,
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
                  controller: categorydescriptioncontroller,
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
                  onPressed: () {
                    print("Button Precced----------------------------");
                    FirebaseServices().addcategory(
                        categoryname: categorynamecontroller.text.toString(),
                        description:
                            categorydescriptioncontroller.text.toString(),
                        image: newimage,
                        context: context);
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(fontSize: 20),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickImage({required source}) async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        newimage = image;
        print("File image path --> ${newimage!.path.toString()}");
      });
    }
  }
}
