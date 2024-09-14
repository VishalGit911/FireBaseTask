import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:user_panel/Views/SignIn/signin_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                    "Enter your 6-digit code",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: PinCodeTextField(
                    pinTheme: PinTheme(
                        inactiveColor: Colors.black,
                        selectedColor: Colors.black,
                        shape: PinCodeFieldShape.box),
                    appContext: context,
                    onChanged: (value) {},
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    animationDuration: Duration(milliseconds: 300),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: IconButton(
                          style: IconButton.styleFrom(
                              fixedSize: Size(60, 60),
                              backgroundColor: Colors.green.shade800,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40))),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterScreen(),
                                ));
                          },
                          icon: Icon(Icons.arrow_forward_ios_outlined)),
                    ),
                  ],
                )
              ],
            ),
            SafeArea(
                child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: IconButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignInScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  icon: Icon(Icons.arrow_back_ios)),
            )),
          ],
        ),
      ),
    );
    ;
  }
}
