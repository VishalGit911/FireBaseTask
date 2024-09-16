import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user_panel/Wieget/common_botton.dart';

class NumberAdd extends StatefulWidget {
  const NumberAdd({super.key});

  @override
  State<NumberAdd> createState() => _NumberAddState();
}

class _NumberAddState extends State<NumberAdd> {
  TextEditingController mobileController = TextEditingController();
  final globalKey = GlobalKey<FormState>();
  bool isLoading = false; // Fixed typo here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: globalKey,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage("assets/images/blur.png"))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Enter your mobile number",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(
                      controller: mobileController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your mobile number";
                        } else if (value.length != 10) {
                          return "Mobile number must be 10 digits";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                          prefixText: "+91  ",
                          hintStyle: TextStyle(fontSize: 20)),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 200),
                      child: CommanButton(
                          onPressed: () async {
                            if (globalKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });

                              try {
                                final currentMobilenumber =
                                    "+91${mobileController.text.toString().trim()}";

                                await FirebaseAuth.instance.verifyPhoneNumber(
                                  phoneNumber: currentMobilenumber,
                                  verificationCompleted:
                                      (phoneAuthCredential) async {
                                    await FirebaseAuth.instance
                                        .signInWithCredential(
                                            phoneAuthCredential);
                                    print("Verification completed");
                                  },
                                  verificationFailed: (error) {
                                    final snackbar = SnackBar(
                                        content:
                                            Text("Failed : ${error.message}"));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackbar);

                                    print(
                                        "Verification failed: ${error.message}");
                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
                                  codeSent:
                                      (verificationId, forceResendingToken) {
                                    print("OTP sent");
                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
                                  codeAutoRetrievalTimeout: (verificationId) {},
                                );
                              } catch (e) {
                                print("Error: $e");
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }
                          },
                          text: isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  "Confirm",
                                  style: TextStyle(fontSize: 20),
                                ),
                          backgroundColor: Colors.green.shade800,
                          foregroundColor: Colors.white),
                    ),
                  )
                ],
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
