import 'dart:async';
import 'package:firebase_testing_user/views/dashboard/home.dart';
import 'package:flutter/material.dart';
import 'onboarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OnBoardingScreen(),)
          //  builder: (context) => HomeScreen()),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Image(
          image: AssetImage("assets/app_logo.png"),
        ),
      ),
    );
  }
}
