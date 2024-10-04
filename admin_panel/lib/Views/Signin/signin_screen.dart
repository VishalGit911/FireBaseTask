import 'package:admin_panel/Firebase/firebase_services.dart';
import 'package:admin_panel/Views/Home/home_screen.dart';
import 'package:admin_panel/Widget/common_botton.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formkey = GlobalKey<FormState>();

  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  void togglechange() {
    setState(() {
      isvisibility = !isvisibility;
    });
  }

  bool isvisibility = false;
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
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
                    left: 20, right: 20, top: 20, bottom: 5),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter valid email";
                    } else {
                      return null;
                    }
                  },
                  controller: emailcontroller,
                  decoration: InputDecoration(
                      hintText: "Email",
                      suffixIcon: Icon(Icons.mail_outline),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 5),
                child: TextFormField(
                  obscureText: isvisibility,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Entere valid password";
                    } else {}
                  },
                  controller: passwordcontroller,
                  decoration: InputDecoration(
                      hintText: "Password",
                      suffixIcon: isvisibility
                          ? IconButton(
                              onPressed: togglechange,
                              icon: Icon(Icons.visibility),
                            )
                          : IconButton(
                              onPressed: togglechange,
                              icon: Icon(Icons.visibility_off)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                ),
              ),
              CommonBotton(
                  isloading: isloading,
                  onPressed: () {
                    signincheck(
                        email: emailcontroller.text.toString(),
                        password: passwordcontroller.text.toString());
                  },
                  text: "Signin")
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signincheck({required email, required password}) async {
    if (formkey.currentState!.validate()) {
      setState(() {
        isloading = true;
      });

      try {
        final user = await FirebaseServicies()
            .signInWithEmailAndPassword(email: email, password: password);

        if (user != null) {
          if (kDebugMode) {
            print(user.email);
            print(user.uid);
          }
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
            (route) => false,
          );
          final snackBar = SnackBar(content: Text("Login SuccessFull"));

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } catch (e) {
        final snackBar = SnackBar(content: Text("Not user found"));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        print("error : ${e}");
      } finally {
        setState(() {
          isloading = false;
        });
      }
    }
  }
}
