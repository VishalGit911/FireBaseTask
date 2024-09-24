import 'dart:io';
import 'package:admin_panel/Model/category_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseServices {
  static FirebaseServices instance = FirebaseServices.named();

  FirebaseServices.named();

  factory FirebaseServices() {
    return instance;
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

  Future<User?> gmailPasswordLogin(
      {required String email, required String password}) async {
    try {
      final credenial = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      return credenial.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addcategory({
    String? categoryname,
    String? description,
    XFile? image,
    int? createdAt,
    String? categoryId,
    String? existingImageUrl,
    required BuildContext context,
  }) async {
    print("call add category function------------------");
    String? newImageUrl;

    int? timstamp = createdAt ?? DateTime.now().millisecondsSinceEpoch;

    newImageUrl = existingImageUrl ?? "";
    if (image != null) {
      String? filename = "${DateTime.now().millisecondsSinceEpoch}.png";

      File file = File(image.path);

      TaskSnapshot snapshot = await _firebaseStorage
          .ref()
          .child("category")
          .child(filename)
          .putFile(file);

      newImageUrl = await snapshot.ref.getDownloadURL();

      print("Image Upload Successfully---------------------");
    }

    CategoryModel category = CategoryModel(
        name: categoryname!,
        description: description!,
        imageUrl: newImageUrl,
        isActive: true,
        createdAt: timstamp,
        id: categoryId);

    if (category.id == null) {
      print("successfully-------------------------------------");

      String? newIdGenerate =
          _firebaseDatabase.ref().child("category").push().key;
      print("NewGenerateId = $newIdGenerate");
      category.id = newIdGenerate;
      await _firebaseDatabase
          .ref()
          .child("category")
          .child(newIdGenerate!)
          .set(category.toJson());

      print("Category add successfully");

      Navigator.pop(context);
    }
  }

  Stream<List<CategoryModel>> getcategory() {
    List<CategoryModel> categoryList = [];
    return _firebaseDatabase.ref().child("category").onValue.map(
      (event) {
        if (event.snapshot.exists) {
          Map<dynamic, dynamic> categoryMap =
              event.snapshot.value as Map<dynamic, dynamic>;

          categoryMap.forEach(
            (key, value) {
              CategoryModel categoryModel = CategoryModel.fromJson(value);

              categoryList.add(categoryModel);
            },
          );
        }
        return categoryList;
      },
    );
  }
}

/*
  Future<void> register(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
 */
