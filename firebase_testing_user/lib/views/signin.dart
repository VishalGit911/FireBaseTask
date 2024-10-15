import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_testing_user/views/verification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final mobileNo = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Image(
                image: AssetImage("assets/veggie_bg.png"),
              ),
              const Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  "Get your groceries \n with nectar",
                  style: TextStyle(color: Colors.black, fontSize: 30),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextFormField(
                  controller: mobileNo,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter valid number";
                    } else if (value.length != 10) {
                      return "Please enter valid mobile number.";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                      border: null,
                      labelText: "Enter Mobile No.",
                      prefixText: "+91",
                      suffixIcon: Icon(Icons.call)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: CustomButton(
                    title: "Continue",
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    callback: () async {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });

                        log("Function called.......");

                        try {
                          String validMobileNumber =
                              "+91${mobileNo.text.toString().trim()}";

                          log(validMobileNumber);

                          await FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: validMobileNumber,
                            verificationCompleted: (phoneAuthCredential) async {
                              log("-------------Verification Completed call------------");

                              await FirebaseAuth.instance
                                  .signInWithCredential(phoneAuthCredential);
                            },
                            verificationFailed: (error) {
                              log("-----------Verification failed....");
                              log(error.toString());
                            },
                            codeSent: (verificationId, forceResendingToken) {
                              log("------------Verification code sent....");

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VerificationScreen(
                                      verificationId: verificationId,
                                    ),
                                  ));
                            },
                            codeAutoRetrievalTimeout: (verificationId) {
                              if (kDebugMode) {
                                print("----------code  timeout");
                              }
                            },
                          );
                        } catch (e) {
                          if (kDebugMode) {
                            print(e.toString());
                          }
                        }
                      }
                    },
                    isLoading: isLoading),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/*
Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerificationScreen(),
                          ));
 */
