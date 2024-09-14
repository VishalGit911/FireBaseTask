import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  static FirebaseServices instance = FirebaseServices.named();

  FirebaseServices.named();

  factory FirebaseServices() {
    return instance;
  }

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
}
