import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app_cracon/Views/authentication/forgot_password_screen.dart';
import 'package:users_app_cracon/Views/authentication/phoneAuthScreen.dart';
import 'package:users_app_cracon/Views/authentication/signup_screen.dart';
import 'package:users_app_cracon/constants.dart';

import '../../Controller/global/global.dart';
import '../splashScreen/splash_screen.dart';
import '../widgets/progress_dialog.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm() {
    if (!emailTextEditingController.text.contains("@")) {
      Fluttertoast.showToast(msg: "Email address is not Valid.");
    } else if (passwordTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Password is required.");
    } else {
      loginUserNow();
    }
  }

  loginUserNow() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(
            message: "Processing, Please wait...",
          );
        });

    final User? firebaseUser = (await fAuth
            .signInWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    )
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error: " + msg.toString());
    }))
        .user;

    if (firebaseUser != null) {
      DatabaseReference driversRef =
          FirebaseDatabase.instance.ref().child("users");
      driversRef.child(firebaseUser.uid).once().then((driverKey) {
        final snap = driverKey.snapshot;
        if (snap.value != null) {
          currentFirebaseUser = firebaseUser;
          Fluttertoast.showToast(msg: "Login Successful.");
          Navigator.push(context,
              MaterialPageRoute(builder: (c) => const MySplashScreen()));
        } else {
          Fluttertoast.showToast(msg: "No record exist with this email.");
          fAuth.signOut();
          Navigator.push(context,
              MaterialPageRoute(builder: (c) => const MySplashScreen()));
        }
      });
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error Occurred during Login.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset("android/images/logo.png"),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Login as a User",
              style: TextStyle(
                fontSize: 26,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: emailTextEditingController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.grey),
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "Email",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15),
                ),
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ),
                labelStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: passwordTextEditingController,
              keyboardType: TextInputType.text,
              obscureText: true,
              style: const TextStyle(color: Colors.grey),
              decoration: InputDecoration(
                labelText: "Password",
                hintText: "Password",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15),
                ),
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ),
                labelStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(color: primary),
                  ),
                  onPressed: () {
                    if (emailTextEditingController.text.isNotEmpty) {
                      fAuth.sendPasswordResetEmail(
                          email: emailTextEditingController.text.trim());
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Check Your Email Inbox. We have sent a link to reset your password"),
                        ),
                      );
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => ForgotPasswordScreen()));
                    }
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                validateForm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: hoverColor,
              ),
              child: const Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        color: textcolor,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "OR",
                        style: TextStyle(
                          color: textcolor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        color: textcolor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (c) => PhoneLoginScreen()),
                          (route) => false);
                    },
                    icon: Icon(
                      Icons.phone,
                      color: primary,
                      size: 30,
                    ),
                  ),
                ),
            TextButton(
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Do not have an Account? ",
                        style: TextStyle(
                          color: textcolor,
                        ),
                      ),
                      Text(
                        "SignUp Here",
                        style: TextStyle(
                            color: primary,
                            decoration: TextDecoration.underline,
                            decorationColor: primary),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (c) => SignUpScreen()),
                        (route) => false);
                  },
                ),
          ],
        ),
      ),
    );
  }
}
