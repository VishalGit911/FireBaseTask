import 'dart:developer';

import 'package:firebase_testing_admin/firebase/firebase_servicies.dart';
import 'package:firebase_testing_admin/views/home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Image(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.fill,
              ),
            ),
            LoginForm()
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void toggleChange() {
    setState(() {
      isVisibility = !isVisibility;
    });
  }

  bool isVisibility = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Image.asset(
                    "assets/images/logo.png",
                  ),
                ),
              ),
              const Text(
                'Admin Login',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                'Enter your email and password',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(
                height: 40,
              ),
              TextFormField(
                controller: emailController,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Enter valid email address";
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    border: null, labelText: " Email Address"),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: passwordController,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Enter valid password";
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.visiblePassword,
                obscureText: isVisibility,
                decoration: InputDecoration(
                  border: null,
                  labelText: "Password",
                  suffixIcon: isVisibility
                      ? IconButton(
                          onPressed: toggleChange,
                          icon: const Icon(Icons.visibility),
                        )
                      : IconButton(
                          onPressed: toggleChange,
                          icon: const Icon(Icons.visibility_off),
                        ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              CustomButton(
                title: "Login",
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                callback: () async {
                  await signInCheck(
                      email: emailController.text.toString(),
                      password: passwordController.text.toString());
                },
                isLoading: isLoading,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signInCheck(
      {required String email, required String password}) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        final user = await FirebaseServicies()
            .signInWithEmailAndPassword(email: email, password: password);

        if (user != null) {
          if (kDebugMode) {
            print(user.uid);
            print(user.email);
            print(user.displayName);
          }

          if (!mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
            (route) => false,
          );
        }
      } catch (e) {

        log(e.toString());
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}

// Xh0hotV9wiSeSd11XzgKeph92oX2
