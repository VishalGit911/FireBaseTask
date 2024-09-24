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
    required BuildContext context,
  }) async {
    String? newImageUrl;

    int? timstamp = createdAt ?? DateTime.now().millisecondsSinceEpoch;

    if (image != null) {
      String? filename = "${DateTime.now().millisecondsSinceEpoch}.png";

      File file = File(image.path);

      TaskSnapshot snapshot = await _firebaseStorage
          .ref()
          .child("category")
          .child(filename)
          .putFile(file);

      newImageUrl = await snapshot.ref.getDownloadURL();
    }

    CategoryModel category = CategoryModel(
        name: categoryname!,
        description: description!,
        imageURL: newImageUrl!,
        isactive: true,
        createdAt: timstamp,
        id: categoryId);

    if (category.id != null) {
      String? newIdGenerate =
          _firebaseDatabase.ref().child("category").push().key;

      category.id = newIdGenerate;
      await _firebaseDatabase
          .ref()
          .child("category")
          .child(newIdGenerate!)
          .set(category.tojson());

      Navigator.pop(context);
    }
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
