import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_testing_user/views/splash.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCElVRO9UBuXTx2gr6VJlGzkmn_xpnwi4w",
          appId: "1:706813487245:android:0f50b2b102db5d2beadac4",
          messagingSenderId: "706813487245",
          projectId: "fir-testing-2e919",
          storageBucket: "fir-testing-2e919.appspot.com"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: SplashScreen(),
    );
  }
}
