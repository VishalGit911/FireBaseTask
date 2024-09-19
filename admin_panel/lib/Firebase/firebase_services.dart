import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  static FirebaseServices instance = FirebaseServices.named();

  FirebaseServices.named();

  factory FirebaseServices() {
    return instance;
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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
