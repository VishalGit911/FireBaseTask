import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseServices {
  static FirebaseServices instance = FirebaseServices.named();

  FirebaseServices.named();

  factory FirebaseServices() {
    return instance;
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

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

  Future<void> addcategoryinfirebase({createdAdt, XFile? image}) async {
    int? timstamp = createdAdt ?? DateTime.now().millisecondsSinceEpoch;

    print("Time Stamp = $timstamp");

    if (image != null) {
      String? filename = "${DateTime.now().millisecondsSinceEpoch}";

      print("Filename = $filename");

      File file = File(image.path);

      print("image path =$file");

      TaskSnapshot snapshot = await _firebaseStorage
          .ref()
          .child("category")
          .child(filename)
          .putFile(file);

      print("File Upload Successfully");
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
