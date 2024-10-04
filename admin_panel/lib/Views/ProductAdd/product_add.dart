import 'dart:io';
import 'package:admin_panel/Widget/common_botton.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../Firebase/firebase_services.dart';
import '../../Model/category_model.dart';
import '../../Model/product_model.dart';

class ProductManageScreen extends StatefulWidget {
  Product? product;
  ProductManageScreen({super.key, this.product});

  @override
  State<ProductManageScreen> createState() => _ProductManageScreenState();
}

class _ProductManageScreenState extends State<ProductManageScreen> {
  XFile? _newImage;
  String? existingImageUrl;

  bool isLoading = false;

  String? categoryId;

  final formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockQuantityController = TextEditingController();

  List<CategoryModel> categoryList = [];

  @override
  initState() {
    if (widget.product != null) {
      existingImageUrl = widget.product!.imageUrl;
      _nameController.text = widget.product!.name;
      _descriptionController.text = widget.product!.description;
      _priceController.text = widget.product!.price.toString();
      _stockQuantityController.text = widget.product!.stock.toString();
      categoryId = widget.product!.categoryId;
    }

    getAllCategory();
    super.initState();
  }

  Future<void> getAllCategory() async {
    List<CategoryModel> categoriesTemp =
        await FirebaseServicies().getCategoryForProductAdd();
    setState(() {
      categoryList = categoriesTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Manage Screen"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    pickImage();
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.blue.shade100,
                    foregroundColor: Colors.white,
                    child: _newImage == null && existingImageUrl != null
                        ? CircleAvatar(
                            radius: 60,
                            foregroundImage: NetworkImage(existingImageUrl!),
                          )
                        : _newImage != null
                            ? CircleAvatar(
                                radius: 60,
                                foregroundImage: FileImage(
                                  File(_newImage!.path),
                                ),
                              )
                            : const Icon(
                                Icons.add,
                                size: 40,
                                color: Colors.white,
                              ),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Item Name'),
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an item name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  decoration:
                      const InputDecoration(labelText: 'Item Description'),
                  keyboardType: TextInputType.multiline,
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an item description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _priceController,
                        decoration: const InputDecoration(labelText: 'Price'),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _stockQuantityController,
                        decoration:
                            const InputDecoration(labelText: 'Stock Quantity'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the stock quantity';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                DropdownButtonFormField(
                  value: categoryId,
                  decoration: InputDecoration(labelText: "Select Category"),
                  items: categoryList.map((e) {
                    return DropdownMenuItem(
                      value: e.id,
                      child: Text(e.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    print(value);
                    categoryId = value;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                CommonBotton(
                  isloading: isLoading,
                  onPressed: () {
                    productAdd();
                  },
                  text:
                      widget.product == null ? "Add Product" : "Update Product",
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
        _newImage = image;
      });
    }
  }

  Future<void> productAdd() async {
    if (formKey.currentState!.validate()) {
      if (existingImageUrl != null || _newImage != null) {
        setState(() {
          isLoading = true;
        });

        await FirebaseServicies().addOrUpdateProductInFirebase(
            productName: _nameController.text.toString(),
            productDesc: _descriptionController.text.toString(),
            productQuantity:
                int.parse(_stockQuantityController.text.toString()),
            productPrice: double.parse(_priceController.text.toString()),
            productCategoryId: categoryId!,
            newImage: _newImage,
            existingImageUrl: null,
            productId: null,
            timeStamp1: null,
            context: context);
      }
    }
  }
}
