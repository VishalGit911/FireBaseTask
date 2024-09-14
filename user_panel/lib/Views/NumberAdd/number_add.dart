// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:user_panel/Wieget/common_botton.dart';
//
// class NumberAdd extends StatefulWidget {
//   const NumberAdd({super.key});
//
//   @override
//   State<NumberAdd> createState() => _NumberAddState();
// }
//
// class _NumberAddState extends State<NumberAdd> {
//   TextEditingController mobileController = TextEditingController();
//
//   final globalKey = GlobalKey<FormState>();
//
//   bool isloding = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Form(
//         key: globalKey,
//         child: SingleChildScrollView(
//           child: Stack(
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     height: 200,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                         image: DecorationImage(
//                             fit: BoxFit.fill,
//                             image: AssetImage("assets/images/blur.png"))),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: Text(
//                       "Enter your mobile number",
//                       style:
//                           TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: TextFormField(
//                       controller: mobileController,
//                       validator: (value) {
//                         setState(() {
//                           print(value);
//                           if (value!.isEmpty) {
//                             print("value null");
//                           } else if (value.length != 10) {
//                             print("value not 10");
//                           }
//                         });
//                       },
//                       decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                               borderSide: BorderSide(color: Colors.black),
//                               borderRadius: BorderRadius.circular(10)),
//                           prefixText: "+91  ",
//                           hintStyle: TextStyle(fontSize: 20)),
//                     ),
//                   ),
//                   Center(
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 200),
//                       child: CommanButton(
//                           onPressed: () async {
//                             if (globalKey.currentState!.validate()) {
//                               setState(() {
//                                 isloding = true;
//                               });
//
//                               try {
//                                 final currentMobilenumber =
//                                     "+91${mobileController.text.toString().trim()}";
//
//                                 await FirebaseAuth.instance.verifyPhoneNumber(
//                                   phoneNumber: currentMobilenumber,
//                                   verificationCompleted:
//                                       (phoneAuthCredential) async {
//                                     await FirebaseAuth.instance
//                                         .signInWithCredential(
//                                             phoneAuthCredential);
//
//                                     print("----------complate------");
//                                   },
//                                   verificationFailed: (error) {
//                                     print("-------field------");
//                                   },
//                                   codeSent:
//                                       (verificationId, forceResendingToken) {
//                                     print("------otp send ----");
//                                   },
//                                   codeAutoRetrievalTimeout: (verificationId) {},
//                                 );
//                               } catch (e) {}
//                             }
//
//                             setState(() {});
//                           },
//                           text:
//                               // text: isloding == true
//                               // ? CircularProgressIndicator(
//                               //     color: Colors.white,
//                               //   ) :
//                               Text(
//                             "Conform",
//                             style: TextStyle(fontSize: 20),
//                           ),
//                           backgroundColor: Colors.green.shade800,
//                           foregroundColor: Colors.white),
//                     ),
//                   )
//                 ],
//               ),
//               SafeArea(
//                   child: Padding(
//                 padding: const EdgeInsets.all(15.0),
//                 child: IconButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     icon: Icon(Icons.arrow_back_ios)),
//               )),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
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

  bool isloding = false;

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
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your phone number';
                        } else if (value.length != 10) {
                          return 'Phone number should be 10 digits long';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                          prefixText: "+91  ",
                          hintStyle: TextStyle(fontSize: 20)),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 200),
                      child: CommanButton(
                        onPressed: () async {
                          if (globalKey.currentState!.validate()) {
                            setState(() {
                              isloding = true;
                            });

                            try {
                              final currentMobilenumber =
                                  "+91${mobileController.text.trim()}";

                              await FirebaseAuth.instance.verifyPhoneNumber(
                                phoneNumber: currentMobilenumber,
                                verificationCompleted:
                                    (PhoneAuthCredential credential) async {
                                  await FirebaseAuth.instance
                                      .signInWithCredential(credential);
                                  print("Verification complete");
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        'Phone number verified and signed in!'),
                                  ));
                                },
                                verificationFailed:
                                    (FirebaseAuthException error) {
                                  print(
                                      "Verification failed: ${error.message}");
                                  setState(() {
                                    isloding = false;
                                  });
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        'Verification failed. Please try again.'),
                                  ));
                                },
                                codeSent:
                                    (String verificationId, int? resendToken) {
                                  print(
                                      "Code sent. Verification ID: $verificationId");
                                  setState(() {
                                    isloding = false;
                                  });
                                  // Navigate to the OTP input screen here
                                },
                                codeAutoRetrievalTimeout:
                                    (String verificationId) {
                                  print("Auto-retrieval timeout.");
                                },
                              );
                            } catch (e) {
                              setState(() {
                                isloding = false;
                              });
                              print("Error: $e");
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content:
                                    Text('Error occurred. Please try again.'),
                              ));
                            }
                          }
                        },
                        text: isloding
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                                "Confirm",
                                style: TextStyle(fontSize: 20),
                              ),
                        backgroundColor: Colors.green.shade800,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
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
              )),
            ],
          ),
        ),
      ),
    );
  }
}
