import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:user_panel/Model/category_model.dart';
import 'package:user_panel/Model/product_model.dart';

class FirebaseServices {
  static FirebaseServices instance = FirebaseServices.named();

  FirebaseServices.named();

  factory FirebaseServices() {
    return instance;
  }

  FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

  Future<UserCredential> gmailPasswordLogin(
      {required String email, required String password}) async {
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    return user;
  }

  static Future<ConfirmationResult> mobileNumberLogin(
      {required phoneNumber}) async {
    final ConfirmationResult =
        await FirebaseAuth.instance.signInWithPhoneNumber(phoneNumber);

    return ConfirmationResult;
  }

  Stream<List<ProductModel>> getallproduct() {
    return _firebaseDatabase.ref().child("product").onValue.map(
      (event) {
        List<ProductModel> productList = [];
        if (event.snapshot.exists) {
          Map<dynamic, dynamic> productMap =
              event.snapshot.value as Map<dynamic, dynamic>;

          productMap.forEach(
            (key, value) {
              ProductModel productModel = ProductModel.fromJson(value);
              productList.add(productModel);
            },
          );
        }
        return productList;
      },
    );
  }

  Stream<List<CategoryModel>> getAllCategory() {
    return _firebaseDatabase.ref().child("category").onValue.map(
      (event) {
        List<CategoryModel> categoryList = [];
        if (event.snapshot.exists) {
          Map<dynamic, dynamic> productMap =
              event.snapshot.value as Map<dynamic, dynamic>;

          productMap.forEach(
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
