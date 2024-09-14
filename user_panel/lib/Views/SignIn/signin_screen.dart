import 'package:flutter/material.dart';
import 'package:user_panel/Views/NumberAdd/number_add.dart';
import 'package:user_panel/Wieget/common_other_login.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(image: AssetImage("assets/images/signin.png")),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "Get your grocereis\nwith nectar",
                style: TextStyle(fontSize: 33, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(
                    top: 20, left: 25, right: 25, bottom: 20),
                child: TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                      hintText: "+91",
                      hintStyle: TextStyle(fontSize: 20)),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NumberAdd(),
                        ));
                  },
                )),
            Center(
                child: Padding(
              padding: const EdgeInsets.only(top: 25, bottom: 30),
              child: Text(
                "Or connect with social media",
                style: TextStyle(fontSize: 18),
              ),
            )),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: CommonOtherLogin(
                    width: 380,
                    height: 60,
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    onPressed: () {},
                    label: Text(
                      "Continue with Google",
                      style: TextStyle(fontSize: 18),
                    ),
                    icon: Image(
                        image: AssetImage("assets/images/google.png"),
                        height: 25,
                        width: 25)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: CommonOtherLogin(
                    width: 380,
                    height: 60,
                    backgroundColor: Colors.blue.shade800,
                    foregroundColor: Colors.white,
                    onPressed: () {},
                    label: Text(
                      "Continue with Facebook",
                      style: TextStyle(fontSize: 18),
                    ),
                    icon: Image(
                        image: AssetImage("assets/images/facebook.png"),
                        height: 25,
                        width: 25)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
