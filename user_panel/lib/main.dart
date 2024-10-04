import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:user_panel/Views/Splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyCCo76xg8rGkANqooquHMFSjR4aT6FFkqM",
          appId: "1:378642322754:android:5628b807f78f10582f64db",
          messagingSenderId: "378642322754",
          projectId: "grocery-app-cad3f",
          storageBucket: "grocery-app-cad3f.appspot.com"));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
