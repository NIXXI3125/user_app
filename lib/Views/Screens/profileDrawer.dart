import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:users_app_cracon/Controller/global/global.dart';
import 'package:users_app_cracon/Views/Screens/RideHistory/rideHistory.dart';
import 'package:users_app_cracon/Views/Screens/helpAndSupport.dart';
import 'package:users_app_cracon/Views/authentication/login_screen.dart';
import 'package:users_app_cracon/models/profileListTileData.dart';

class Profiledrawer extends StatelessWidget {
  Profiledrawer({super.key});

  @override
  Widget build(BuildContext context) {
    List<Profilelisttiledata> tilesData = [
      Profilelisttiledata(
        title: 'Edit Profile',
        leadingIcon: Icons.person,
        onTap: () {
          // Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
          //   return ();
          // }));
        },
      ),
      // Profilelisttiledata(
      //   title: 'Ride History',
      //   leadingIcon: Icons.history,
      //   onTap: () {
      //     Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
      //       return Ridehistory();
      //     }));
      //   },
      // ),
      // Profilelisttiledata(
      //   title: 'Refer & Earn',
      //   leadingIcon: Icons.payments_rounded,
      //   onTap: () {
      //     Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
      //       return Ridehistory();
      //     }));
      //   },
      // ),
      Profilelisttiledata(
        title: 'Privacy Policy',
        leadingIcon: Icons.privacy_tip,
        onTap: () async {
          await launchUrl(
            Uri(
              scheme: 'https',
              host: 'www.cracon.in',
              path: 'privacy-policy',
            ),
            mode: LaunchMode.inAppBrowserView,
          );
        },
      ),
      Profilelisttiledata(
        title: 'Help & Support',
        leadingIcon: Icons.headset_mic_rounded,
        onTap: () async {
          Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
            return Helpandsupport();
          }));
        },
      ),
      Profilelisttiledata(
          title: 'Logout',
          leadingIcon: Icons.logout,
          onTap: () {
            fAuth.signOut();
            Navigator.of(context).pushAndRemoveUntil(
                CupertinoPageRoute(builder: (context) => LoginScreen()),
                (route) => false);
          },
          iconColor: Colors.red),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Menu',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // Shadow color
                  spreadRadius: 1, // How far the shadow spreads
                  blurRadius: 5, // Softness of the shadow
                  offset: Offset(0, 3), // Shadow position (x, y)
                ),
              ],
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Container(
                  height: 70,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black,
                      width: 0.5,
                    ),
                  ),
                  child: Icon(
                    Icons.person,
                    size: 45,
                    color: Colors.orange.shade400,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userModelCurrentInfo!.name ?? '',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      userModelCurrentInfo!.phone ?? '',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                          color: Colors.black87),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          ...List.generate(
            tilesData.length,
            (index) {
              return customTile(
                  tilesData[index].title,
                  tilesData[index].leadingIcon,
                  tilesData[index].onTap,
                  tilesData[index].iconColor);
            },
          ),
        ],
      ),
    );
  }
}

Widget customTile(
  String title,
  IconData leadingIcon,
  void Function() onTap,
  Color? iconColor,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    child: Column(
      children: [
        ListTile(
          title: Text(title),
          leading: Icon(
            leadingIcon,
            color: iconColor ?? Colors.black,
          ),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.black,
          ),
          onTap: onTap,
        ),
        Divider(
          color: Colors.grey.shade400,
        )
      ],
    ),
  );
}
