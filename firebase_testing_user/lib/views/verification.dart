import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_testing_user/firebase/firebase_servicies.dart';
import 'package:firebase_testing_user/views/dashboard/home.dart';
import 'package:firebase_testing_user/views/register.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../widgets/custom_button.dart';

class VerificationScreen extends StatefulWidget {
  final String verificationId;

  const VerificationScreen({super.key, required this.verificationId});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final otpController = TextEditingController();

  bool isLoading = false;

  final formKey = GlobalKey<FormState>();

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
              Image.asset("assets/veggie_bg.png"),
              const Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  "Verify your \n Mobile Number",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.w900),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: PinCodeTextField(
                  appContext: context,
                  length: 6,
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  obscureText: false,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeColor: Colors.green,
                    disabledColor: Colors.blue,
                    activeFillColor: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: CustomButton(
                    title: "Verify and Continue",
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    callback: () async {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });

                        try {
                          // Create a PhoneAuthCredential with the code
                          PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: widget.verificationId,
                                  smsCode:
                                      otpController.text.toString().trim());

                          UserCredential? user = await FirebaseAuth.instance
                              .signInWithCredential(credential);

                          if (user.user != null) {
                            if (kDebugMode) {
                              print(user.user!.phoneNumber.toString());
                              print(user.user!.uid.toString());
                            }

                            onSuccess(user);
                          }
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

  onSuccess(UserCredential userCredential) {
    FirebaseServicies().userExistOrNot(userCredential.user!.uid).then(
      (value) {
        if (value) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegisterScreen(),
              ));
        }
      },
    );
  }
}
