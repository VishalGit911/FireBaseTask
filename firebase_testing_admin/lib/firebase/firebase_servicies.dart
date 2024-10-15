import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_testing_admin/model/category.dart';
import 'package:firebase_testing_admin/model/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../model/dashboard.dart';
import '../model/order.dart';
import '../model/user.dart';

class FirebaseServicies {
  static FirebaseServicies instance = FirebaseServicies.named();

  FirebaseServicies.named();

  factory FirebaseServicies() {
    return instance;
  }

  // int a = 10;
  // int b = 20;
  //
  // void test() {
  //   print("The sum of a and b is ${a + b}");
  // }

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
      // print(e.code);
      // print(e.message);
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


    if (image != null) {

      String? filename = "${DateTime.now().millisecondsSinceEpoch}.png";


      File imageFile = File(image.path);


      TaskSnapshot snapshot = await _storage
          .ref()
          .child("Category")
          .child(filename)
          .putFile(imageFile);


      newImageUrl = await snapshot.ref.getDownloadURL();

    }

    //  upload all category data into real time database

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


      category.id = newIdGenerate;

      await _firebaseDatabase
          .ref()
          .child("category")
          .child(newIdGenerate!)
          .set(category.toJson());


      Navigator.pop(context);
    } else {
      _firebaseDatabase
          .ref()
          .child("category")
          .child(categoryId!)
          .update(category.toJson());


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

      if (event.snapshot.exists) {
        Map<dynamic, dynamic> categoryMap =
            event.snapshot.value as Map<dynamic, dynamic>;


        categoryMap.forEach((key, value) {

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

      log("Timestamp : $timeStamp");

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
      } else {
        _firebaseDatabase
            .ref()
            .child("product")
            .child(productId!)
            .update(product.toJson());

        Navigator.pop(context);
      }
    } catch (e) {
      log(e.toString());
      throw e;
    }
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

  Future<void> updateInTopStatus(
      {required String productId, required bool status}) async {
    await _firebaseDatabase
        .ref()
        .child("product")
        .child(productId)
        .update({"inTop": status});
  }

  Stream<List<UserData>> userData() {
    return _firebaseDatabase.ref().child("users").onValue.map(
      (event) {
        List<UserData> userList = [];

        if (event.snapshot.exists) {
          Map<dynamic, dynamic> userMap =
              event.snapshot.value as Map<dynamic, dynamic>;

          userMap.forEach(
            (key, value) {
              UserData userData = UserData.fromJson(value);
              userList.add(userData);
            },
          );
        }

        return userList;
      },
    );
  }

  Stream<DashboardData> fetchDashboardData() {
    try {
      return _firebaseDatabase.ref().onValue.map((event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};


        return DashboardData(
          totalCategories:
              data['category'] != null ? data['category'].length : 0,
          totalUsers: data['users'] != null ? data['users'].length : 0,
          totalOrders: data['orders'] != null ? data['orders'].length : 0,
          totalProduct: data['product'] != null ? data['product'].length : 0,
        );
      });
    } catch (e) {
      throw Exception('Failed to load dashboard data');
    }
  }

  Stream<List<Order>> orderStream() {
   // var userId = _firebaseAuth.currentUser!.uid;

    return _firebaseDatabase
        .ref()
        .child('orders')
        .onValue
        .map((event) {
      dynamic ordersMap = event.snapshot.value ?? {};
      List<Order> orders = [];
      ordersMap.forEach((key, value) {
        orders.add(
          Order.fromJson(
            Map<String, dynamic>.from(value),
          ),
        );
      });
      return orders;
    });
  }
}
