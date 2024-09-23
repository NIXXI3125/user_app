import 'package:flutter/material.dart';

class Underconstructionscreen extends StatelessWidget {
  const Underconstructionscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('android/images/under_construction.png'),
            Text('We\'re \n Under Construction', textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),),
          ],
        ),
      ),
    );
  }
}