import 'package:admin_panel/Views/Splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyCCo76xg8rGkANqooquHMFSjR4aT6FFkqM",
          appId: "1:378642322754:android:5628b807f78f10582f64db",
          messagingSenderId: "378642322754",
          projectId: "grocery-app-cad3f",
          storageBucket: "grocery-app-cad3f.appspot.com"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
