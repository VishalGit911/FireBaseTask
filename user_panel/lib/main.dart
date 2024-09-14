import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:user_panel/Views/Splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCfKTjzO437DcHpCoH2AKzjCGnBZ11sB2I",
          appId: "1:812976997150:android:59f23e37777d14b87dbf0f",
          messagingSenderId: "812976997150",
          projectId: "fruit-app-5e199",
          storageBucket: "fruit-app-5e199.appspot.com"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
