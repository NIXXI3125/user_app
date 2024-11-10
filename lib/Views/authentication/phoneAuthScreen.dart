import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app_cracon/Controller/global/global.dart';
import 'package:users_app_cracon/Views/authentication/login_screen.dart';
import 'package:users_app_cracon/Views/authentication/otpScreen.dart';
import 'package:users_app_cracon/Views/authentication/signup_screen.dart';
import 'package:users_app_cracon/Views/widgets/progress_dialog.dart';
import 'package:users_app_cracon/constants.dart';

class PhoneLoginScreen extends StatefulWidget {
  @override
  _PhoneLoginScreenState createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  TextEditingController phoneTextEditingController = TextEditingController();
  User? firebaseUser;
  validateForm() {
    loginDriverNow();
  }

  loginDriverNow() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(
            message: "Processing, Please wait...",
          );
        });

    await fAuth
        .verifyPhoneNumber(
      phoneNumber: "+91${phoneTextEditingController.text.trim()}",
      codeAutoRetrievalTimeout: (String verificationId) {
        // Navigator.pop(context);
        Fluttertoast.showToast(msg: "Auto Retrieval Timeout.");
      },
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {},
      verificationFailed: (FirebaseAuthException authException) {},
      codeSent: (verificationId, forceResendingToken) {
        print("Verification ID: $verificationId");
        Fluttertoast.showToast(msg: "Verification Code has been sent.");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => otpScreen(
              phone: phoneTextEditingController.text.trim(),
              verificationId: verificationId,
              forSignup: false,
            ),
          ),
        );
      },
    )
        .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error: " + msg.toString());
    });
    // if (firebaseUser != null) {
    //   DatabaseReference driversRef =
    //       FirebaseDatabase.instance.ref().child("drivers");
    //   driversRef.child(firebaseUser.uid).once().then((driverKey) {
    //     final snap = driverKey.snapshot;
    //     if (snap.value != null) {
    //       currentFirebaseUser = firebaseUser;
    //       UserModel user = UserModel.fromSnapshot(snap);
    //       if (firebaseUser.emailVerified) {
    //         if (user.car_details != null && user.driver_details != null) {
    //           print(user.driver_details);
    //           Fluttertoast.showToast(msg: "Login Successful.");
    //           Navigator.push(context,
    //               MaterialPageRoute(builder: (c) => const MySplashScreen()));
    //         } else {
    //           Fluttertoast.showToast(msg: "Please Complete Your Profile.");
    //           Navigator.pushAndRemoveUntil(
    //               context,
    //               MaterialPageRoute(builder: (c) => CarInfoScreen()),
    //               (route) => false);
    //         }
    //       } else {
    //         Fluttertoast.showToast(
    //             msg: "Email is Not Verified. Check Your Email.");
    //         fAuth.signOut();
    //         Navigator.pop(context);
    //       }
    //     } else {
    //       Fluttertoast.showToast(msg: "No Record Exist With This Email.");
    //       fAuth.signOut();
    //       Navigator.pushAndRemoveUntil(
    //           context,
    //           MaterialPageRoute(builder: (c) => const MySplashScreen()),
    //           (route) => false);
    //     }
    //   });
    // } else {
    //   Navigator.pop(context);
    //   Fluttertoast.showToast(msg: "Error Occurred during Login.");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: background,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset(
                    "android/images/logo.png",
                    height: 250,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Welcome to Cracon!",
                  style: TextStyle(
                    fontSize: 30,
                    color: primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: phoneTextEditingController,
                  keyboardType: TextInputType.emailAddress,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                  ],
                  style: const TextStyle(color: textcolor, fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: "Phone Number",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primary),
                    ),
                    hintStyle: TextStyle(
                      color: Color.fromRGBO(33, 33, 33, 0.7),
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
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
                          MaterialPageRoute(builder: (c) => LoginScreen()),
                          (route) => false);
                    },
                    icon: Icon(
                      Icons.mail,
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
        ),
      ),
    );
  }
}
