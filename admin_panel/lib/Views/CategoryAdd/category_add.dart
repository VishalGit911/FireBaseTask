import 'dart:developer';
import 'dart:io';
import 'package:admin_panel/Widget/common_botton.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../Firebase/firebase_services.dart';
import '../../Model/category_model.dart';

class CategoryManageScreen extends StatefulWidget {
  CategoryModel? categoryModel;

  CategoryManageScreen({super.key, this.categoryModel});

  @override
  State<CategoryManageScreen> createState() => _CategoryManageScreenState();
}

class _CategoryManageScreenState extends State<CategoryManageScreen> {
  @override
  void initState() {
    if (widget.categoryModel != null) {
      categoryName.text = widget.categoryModel!.name;
      categoryDescription.text = widget.categoryModel!.description;
      existingImageUrl = widget.categoryModel!.imageUrl;
    }
    super.initState();
  }

  XFile? newImage;

  final categoryName = TextEditingController();
  final categoryDescription = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  String? existingImageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Category Manage Screen"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    await pickImage();
                  },
                  child: CircleAvatar(
                    radius: 50,
                    // child: newImage != null
                    //     ? Image.file(File(newImage!.path))
                    //     : Icon(Icons.add),
                    backgroundImage:
                        existingImageUrl != null && newImage == null
                            ? NetworkImage(existingImageUrl!)
                            : newImage != null
                                ? FileImage(
                                    File(newImage!.path),
                                  )
                                : const AssetImage("assets/images/app_logo.png")
                                    as ImageProvider,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: categoryName,
                  decoration: const InputDecoration(
                      border: null, labelText: "Enter Category Name"),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: categoryDescription,
                  maxLines: 5,
                  decoration: const InputDecoration(
                      border: null, labelText: "Enter Category Description"),
                ),
                const SizedBox(
                  height: 50,
                ),
                CommonBotton(
                  isloading: isLoading,
                  onPressed: () {
                    addCategory(
                        categoryName: categoryName.text.toString(),
                        categoryDesc: categoryDescription.text.toString(),
                        image: newImage);
                  },
                  text: widget.categoryModel != null
                      ? "Update Category"
                      : "Add Category",
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        newImage = image;
        // print(newImage!.path);
        log(newImage!.path);
      });
    }
  }

  Future<void> addCategory(
      {required String categoryName,
      required String categoryDesc,
      required XFile? image}) async {
    await FirebaseServicies().addCategoryInDataBase(
        context: context,
        categoryName: categoryName,
        categoryDesc: categoryDesc,
        image: newImage,
        categoryId: widget.categoryModel?.id,
        createdAt: widget.categoryModel?.createdAt,
        existingImageUrl: widget.categoryModel?.imageUrl);
  }
}
