import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Model/category_model.dart';
import '../Model/product_model.dart';

class FirebaseServicies {
  static FirebaseServicies instance = FirebaseServicies.named();

  FirebaseServicies.named();

  factory FirebaseServicies() {
    return instance;
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<User?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      return credential.user;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> signOutAdmin() async {
    await _firebaseAuth.signOut();
  }

  Future<void> addCategoryInDataBase({
    String? categoryName,
    String? categoryDesc,
    XFile? image,
    int? createdAt,
    String? categoryId,
    String? existingImageUrl,
    required BuildContext context,
  }) async {
    int? timeStamp = createdAt ?? DateTime.now().millisecondsSinceEpoch;
    String? newImageUrl;
    newImageUrl = existingImageUrl ?? "";
    print("TimeStamp : $timeStamp");
    if (image != null) {
      String? filename = "${DateTime.now().millisecondsSinceEpoch}.png";
      print("FileName : $filename");
      File imageFile = File(image.path);
      print("File : $imageFile");
      TaskSnapshot snapshot = await _storage
          .ref()
          .child("Category")
          .child(filename)
          .putFile(imageFile);
      print("Image Uploaded in storage");
      newImageUrl = await snapshot.ref.getDownloadURL();
      print("NewImageUrl = $newImageUrl");
    }
    CategoryModel category = CategoryModel(
        name: categoryName!,
        description: categoryDesc!,
        imageUrl: newImageUrl,
        isActive: true,
        createdAt: timeStamp,
        id: categoryId);

    if (category.id == null) {
      String? newIdGenerate =
          _firebaseDatabase.ref().child("Category").push().key;
      print("NewGenerateId = $newIdGenerate");
      category.id = newIdGenerate;
      await _firebaseDatabase
          .ref()
          .child("category")
          .child(newIdGenerate!)
          .set(category.toJson());

      print("Category add successfully");

      Navigator.pop(context);
    } else {
      _firebaseDatabase
          .ref()
          .child("category")
          .child(categoryId!)
          .update(category.toJson());

      print("category Updated Successfully");

      Navigator.pop(context);
    }
  }

  //  get all category data from database.

  /*
  [
  CategoryModel(),
  CategoryModel()
  ]
   */

  Stream<List<CategoryModel>> getCategory() {
    return _firebaseDatabase.ref().child("category").onValue.map((event) {
      List<CategoryModel> categoryList = [];

      print("event.snapshot.exists : ${event.snapshot.exists}");
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> categoryMap =
            event.snapshot.value as Map<dynamic, dynamic>;

        print("categoryMap : ${categoryMap}");

        categoryMap.forEach((key, value) {
          print("Value : $value");

          CategoryModel categoryModel = CategoryModel.fromJson(value);
          categoryList.add(categoryModel);
        });
      }
      return categoryList;
    });
  }

  Future<bool> removeCategory({required String categoryId}) async {
    try {
      await _firebaseDatabase
          .ref()
          .child("category")
          .child(categoryId)
          .remove();

      return true;
    } catch (e) {
      print(e.toString());

      return false;
    }
  }

  Future<List<CategoryModel>> getCategoryForProductAdd() async {
    List<CategoryModel> categoryList = [];

    DataSnapshot snapshot =
        await _firebaseDatabase.ref().child("category").get();

    if (snapshot.exists) {
      Map<dynamic, dynamic> categoryMap =
          snapshot.value as Map<dynamic, dynamic>;

      categoryMap.forEach(
        (key, value) {
          CategoryModel categoryModel = CategoryModel.fromJson(value);

          categoryList.add(categoryModel);
        },
      );
    }

    return categoryList;
  }

  Future<void> addOrUpdateProductInFirebase(
      {required String productName,
      required String productDesc,
      required int productQuantity,
      required double productPrice,
      required String productCategoryId,
      required BuildContext context,
      String? productId,
      XFile? newImage,
      String? existingImageUrl,
      int? timeStamp1}) async {
    try {
      int? timeStamp = timeStamp1 ?? DateTime.now().millisecondsSinceEpoch;

      log("TimeStamo : $timeStamp");

      String imageUrl = existingImageUrl ?? "";

      log("imageUrl : $imageUrl");

      if (newImage != null) {
        String filePath = "${DateTime.now().millisecondsSinceEpoch}.png";

        log("FilePath : $filePath");

        File file = File(newImage.path);

        TaskSnapshot taskSnapshot =
            await _storage.ref().child("product").child(filePath).putFile(file);

        imageUrl = await taskSnapshot.ref.getDownloadURL();

        log("ImageUrl : $imageUrl");
      }

      Product product = Product(
          name: productName,
          description: productDesc,
          price: productPrice,
          stock: productQuantity,
          imageUrl: imageUrl,
          createdAt: timeStamp,
          categoryId: productCategoryId,
          inTop: false,
          id: productId);

      log("Product id : ${product.id}");

      if (product.id == null) {
        String? productNewId =
            _firebaseDatabase.ref().child("product").push().key;

        log("New Product Id : ${productNewId}");

        product.id = productNewId;

        await _firebaseDatabase
            .ref()
            .child("product")
            .child(productNewId!)
            .set(product.toJson());

        log("Product Add Successfully");

        Navigator.pop(context);
      }
    } catch (e) {}
  }

  Stream<List<Product>> getAllProduct() {
    return _firebaseDatabase.ref().child("product").onValue.map(
      (event) {
        List<Product> productList = [];

        if (event.snapshot.exists) {
          Map<dynamic, dynamic> singleEvent =
              event.snapshot.value as Map<dynamic, dynamic>;

          singleEvent.forEach(
            (key, value) {
              Product product = Product.fromJson(value);
              productList.add(product);
            },
          );
        }

        return productList;
      },
    );
  }

  Future<bool> deleteProduct({required String productId}) async {
    try {
      await _firebaseDatabase.ref().child("product").child(productId).remove();

      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
