import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:users_app_cracon/Controller/global/global.dart';

class Helpandsupport extends StatelessWidget {
  const Helpandsupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:
            const Text('Help & Support', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Image.asset(
            'assets/help.gif',
            height: 300,
          ),
          const Text(
            'Need Help?',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          InkWell(
            onTap: () async {
              await launchUrl(
                Uri(
                  scheme: 'tel',
                  path: '+91$customer_care',
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.call_sharp,
                    size: 40,
                    color: Colors.green,
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Text(
                    '+91 - $customer_care',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              await launchUrl(
                Uri(
                  scheme: 'mailto',
                  path: 'admin@cracon.in',
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.mail,
                    size: 40,
                    color: Colors.green,
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Text(
                    'admin@cracon.in',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
