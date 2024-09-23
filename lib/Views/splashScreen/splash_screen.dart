import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app_cracon/Controller/assistants/assistant_methods.dart';
import 'package:users_app_cracon/Controller/providers/landingScreenProvider.dart';
import 'package:users_app_cracon/Views/Screens/LandingScreens/landingScreen.dart';
import 'package:users_app_cracon/Views/authentication/login_screen.dart';
import 'package:users_app_cracon/Controller/global/global.dart';
import 'package:users_app_cracon/Views/mainScreens/main_screen.dart';
import 'package:users_app_cracon/Views/mainScreens/underConstructionScreen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  startTimer() {
    fAuth.currentUser != null
        ? AssistantMethods.readCurrentOnlineUserInfo()
        : null;
    Timer(const Duration(seconds: 3), () async {
      var underConstruction =
          await fbase.child('ExtData').child('userconstruction').once();
      print('Result' + underConstruction.snapshot.value.toString());
      if (fAuth.currentUser != null) {
        if (underConstruction.snapshot.value as bool) {
          currentFirebaseUser = fAuth.currentUser;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) => ChangeNotifierProvider(
                        create: (context) => Landingscreenprovider(),
                        child: LandingScreen(),
                      )));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Underconstructionscreen(),
              ));
        }
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => LoginScreen()));
      }
    });
  }

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("android/images/logo.png"),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Low Fare , Your Care",
                style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
