import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:users_app_cracon/Controller/global/global.dart';
import 'package:users_app_cracon/Views/authentication/phoneAuthScreen.dart';
import 'package:users_app_cracon/Views/authentication/signup_screen.dart';
import 'package:users_app_cracon/Views/splashScreen/splash_screen.dart';
import 'package:users_app_cracon/models/user_model.dart';

class otpScreen extends StatelessWidget {
  otpScreen({
    super.key,
    required this.phone,
    required this.verificationId,
    required this.forSignup,
    this.nameController,
    this.emailController,
  });
  TextEditingController otpcontroller = TextEditingController();
  final String phone;
  final String verificationId;
  final bool forSignup;
  final String? nameController;
  final String? emailController;
  User? firebaseUser;
  @override
  Widget build(BuildContext context) {
    const borderColor = Color.fromRGBO(114, 178, 238, 1);
    const errorColor = Color.fromRGBO(255, 234, 238, 1);
    const fillColor = Color.fromRGBO(222, 231, 240, .57);
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Verification',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(30, 60, 87, 1),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Enter the code sent to the number',
              style: TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(133, 153, 170, 1),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '+91-$phone',
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(30, 60, 87, 1),
              ),
            ),
            const SizedBox(height: 32),
            Pinput(
              length: 6,
              controller: otpcontroller,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: defaultPinTheme.copyWith(
                height: 68,
                width: 64,
                decoration: defaultPinTheme.decoration!.copyWith(
                  border: Border.all(color: borderColor),
                ),
              ),
              errorPinTheme: defaultPinTheme.copyWith(
                decoration: BoxDecoration(
                  color: errorColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                if (forSignup) {
                  try {
                    PhoneAuthCredential phoneAuthCredential =
                        await PhoneAuthProvider.credential(
                            verificationId: verificationId,
                            smsCode: otpcontroller.text);
                    firebaseUser = (await FirebaseAuth.instance
                            .signInWithCredential(phoneAuthCredential)
                            .catchError((msg) {
                      Navigator.pop(context);
                      Fluttertoast.showToast(msg: "Error: " + msg.toString());
                    }))
                        .user;
                    if (firebaseUser != null) {
                      Map userMap = {
                        "id": firebaseUser!.uid,
                        "name": nameController!.trim(),
                        "email": emailController!.trim(),
                        "phone": phone.trim(),
                      };

                      DatabaseReference reference =
                          FirebaseDatabase.instance.ref().child("users");
                      reference.child(firebaseUser!.uid).set(userMap);

                      currentFirebaseUser = firebaseUser;
                      Fluttertoast.showToast(msg: "Account has been Created.");
                      Navigator.push(context,
                          MaterialPageRoute(builder: (c) => MySplashScreen()));
                    } else {
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                          msg: "Account has not been Created.");
                    }
                  } catch (e) {
                    print(e);
                  }
                } else {
                  try {
                    PhoneAuthCredential phoneAuthCredential =
                        PhoneAuthProvider.credential(
                            verificationId: verificationId,
                            smsCode: otpcontroller.text);
                    firebaseUser = (await FirebaseAuth.instance
                            .signInWithCredential(phoneAuthCredential)
                            .catchError((msg) {
                      Navigator.pop(context);
                      Fluttertoast.showToast(msg: "Error: " + msg.toString());
                    }))
                        .user;
                    if (firebaseUser != null) {
                      DatabaseReference driversRef =
                          FirebaseDatabase.instance.ref().child("users");
                      driversRef
                          .child(firebaseUser!.uid)
                          .once()
                          .then((driverKey) {
                        final snap = driverKey.snapshot;
                        if (snap.value != null) {
                          currentFirebaseUser = firebaseUser;
                          Fluttertoast.showToast(msg: "Login Successful.");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => const MySplashScreen()));
                        } else {
                          Fluttertoast.showToast(msg: "Please Register First");
                          fAuth.signOut();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => SignUpScreen()));
                        }
                      });
                    } else {
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                          msg: "Error Occurred during Login.");
                    }
                  } catch (e) {
                    print(e);
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(114, 178, 238, 1),
                minimumSize: const Size(200, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Verify',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
