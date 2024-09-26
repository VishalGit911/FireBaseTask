import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductAdd extends StatefulWidget {
  const ProductAdd({super.key});

  @override
  State<ProductAdd> createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController productQuantityController = TextEditingController();

  XFile? newImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
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
                                pickimage(source: ImageSource.camera);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.photo_library),
                              title: const Text("Gallery"),
                              onTap: () {
                                Navigator.of(context).pop();
                                pickimage(source: ImageSource.gallery);
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
                backgroundImage: newImage != null
                    ? FileImage(File(newImage!.path))
                    : AssetImage("assets/images/logo.png") as ImageProvider,
                radius: 100,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
              child: TextFormField(
                controller: productNameController,
                decoration: InputDecoration(
                    hintText: "Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, left: 15, right: 15, bottom: 10),
              child: TextFormField(
                controller: productDescController,
                maxLines: 4,
                decoration: InputDecoration(
                    hintText: "Description",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: TextFormField(
                        controller: productDescController,
                        decoration: InputDecoration(
                            hintText: "Price",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15))),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextFormField(
                        controller: productDescController,
                        decoration: InputDecoration(
                            hintText: "Quantity",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 5, bottom: 30),
              child: TextFormField(
                controller: productDescController,
                decoration: InputDecoration(
                    hintText: "Quantity",
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

  Future<void> pickimage({required source}) async {
    ImagePicker picker = ImagePicker();

    XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        newImage = image;
      });
    }
  }
}
