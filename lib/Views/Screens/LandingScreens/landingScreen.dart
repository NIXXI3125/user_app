import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:users_app_cracon/Controller/global/global.dart';
import 'package:users_app_cracon/Controller/providers/landingScreenProvider.dart';
import 'package:users_app_cracon/Controller/providers/mainScreenProvider.dart';
import 'package:users_app_cracon/Views/Screens/profileDrawer.dart';
import 'package:users_app_cracon/Views/authentication/login_screen.dart';
import 'package:users_app_cracon/Views/mainScreens/main_screen.dart';
import 'package:users_app_cracon/models/predicted_placestu.dart';

class LandingScreen extends StatefulWidget {
  LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  List vehicles = [
    "Hydra",
    "Excevator",
    "Fork lift",
    "Bike",
  ];
  LocationPermission? _locationPermission;
  List vehicles2 = [
    "TRANSPORT",
    "HEAVY VEHICLE",
  ];

  List<Color> bgColors = [
    const Color(0xFFFBDCDA),
    const Color(0xFFD4EEFE),
    const Color(0xFFFAE6D5),
    const Color(0xFFEFCFE7),
  ];
  @override
  initState() {
    super.initState();
    fetchingImages();
    checkIfLocationPermissionAllowed();
  }

  String bannerlink = '';
  String heavy = '';
  String water = '';

  fetchingImages() async {
    fbase.child('ExtData/book_here').once().then((value) {
      setState(() {
        bannerlink = value.snapshot.value.toString();
      });
    });
    fbase.child('ExtData/heavy').once().then((value) {
      setState(() {
        heavy = value.snapshot.value.toString();
      });
    });
    fbase.child('ExtData/water').once().then((value) {
      setState(() {
        water = value.snapshot.value.toString();
      });
    });
  }

  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
    await context.read<Landingscreenprovider>().getPickupLocation();
  }

  @override
  Widget build(BuildContext context) {
    print(bannerlink);
    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Consumer<Landingscreenprovider>(
            builder: (context, landingprovider, _) {
          return Column(
            children: [
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pickup Location',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Color(0xFFFF914D),
                            ),
                            Text(
                              (landingprovider.list != null)
                                  ? landingprovider.list![0].subLocality!
                                  : "Address Loading",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Icon(
                            //   Icons.arrow_drop_down,
                            //   color: Color(0xFFFF914D),
                            // ),
                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) {
                            return Profiledrawer();
                          },
                        ));
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        margin: const EdgeInsets.all(5),
                        child: Icon(
                          Icons.person,
                          size: 25,
                          color: Colors.green,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.green.shade50),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     Container(
              //       width: MediaQuery.of(context).size.width / 1.4,
              //       padding:
              //           const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              //       decoration: BoxDecoration(
              //         color: const Color(0xFFF3F3F3),
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       child: Center(
              //         child: TextFormField(
              //           keyboardType: TextInputType.text,
              //           onChanged: (value) {
              //             landingprovider.getLocationsFromString(value);
              //           },
              //           decoration: const InputDecoration(
              //               hintText: "Search Pickup Location...",
              //               border: InputBorder.none,
              //               prefixIcon: Icon(Icons.search),
              //               alignLabelWithHint: true),
              //         ),
              //       ),
              //     ),
              //     InkWell(
              //       onTap: () {},
              //       child: Container(
              //         padding: const EdgeInsets.all(15),
              //         decoration: BoxDecoration(
              //           color: const Color(0xFFFF914D),
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //         child: const Icon(
              //           Icons.gps_fixed_outlined,
              //           color: Colors.white,
              //           size: 28,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset("images/banner.png"),
                ),
              ),
              const Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Book Here",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // TextButton(
                    //   onPressed: () {},
                    //   child: const Text(
                    //     "See All",
                    //     style: TextStyle(
                    //       color: Color(0xFFFF914D),
                    //       fontSize: 17,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                  create: (context) => Mainscreenprovider(),
                                  child: MainScreen(),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 170,
                                  width: 170,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    child: Image.asset(
                                      "assets/heavyVehicles.png",
                                      fit: BoxFit.cover,
                                      height: 170,
                                      width: 170,
                                      alignment: Alignment.center,
                                    )
                                  ),
                                ),
                                Text(
                                  "Heavy Vehicles",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                  create: (context) => Mainscreenprovider(),
                                  child: MainScreen(),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 170,
                                  width: 170,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    child: Image.asset(
                                      "assets/waterTanker.jpeg",
                                      fit: BoxFit.cover,
                                      height: 170,
                                      width: 170,
                                      alignment: Alignment.center,

                                    )
                                  ),
                                ),
                                Text(
                                  "Water Tanker",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => ChangeNotifierProvider(
                              create: (context) => Mainscreenprovider(),
                              child: MainScreen(),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 200,
                        width: double.infinity * 0.9,
                        margin: const EdgeInsets.all(5),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 170,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                child: Image.asset(
                                  "assets/deliveryVehicles.png",
                                  fit: BoxFit.fitHeight,
                                  height: 170,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                )
                              ),
                            ),
                            Text(
                              "Delivery Vehicles",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       const Text(
              //         "Services",
              //         style: TextStyle(
              //           fontSize: 22,
              //           fontWeight: FontWeight.w500,
              //         ),
              //       ),
              //       TextButton(
              //         onPressed: () {},
              //         child: const Text(
              //           "View",
              //           style: TextStyle(
              //             color: Color(0xFFFF914D),
              //             fontSize: 17,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // SizedBox(
              //   height: 120,
              //   child: ListView.builder(
              //     scrollDirection: Axis.horizontal,
              //     shrinkWrap: true,
              //     itemCount: vehicles.length,
              //     itemBuilder: (context, index) {
              //       return Container(
              //         width: 100,
              //         margin: const EdgeInsets.only(left: 15),
              //         padding: const EdgeInsets.symmetric(vertical: 5),
              //         decoration: BoxDecoration(
              //           color: bgColors[index],
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //           children: [
              //             Image.asset(
              //               "images/${vehicles[index]}.png",
              //               height: 80,
              //               width: 80,
              //             ),
              //             Text(
              //               vehicles[index],
              //               style: const TextStyle(
              //                 fontWeight: FontWeight.w500,
              //                 fontSize: 15,
              //                 color: Colors.black87,
              //               ),
              //             ),
              //           ],
              //         ),
              //       );
              //     },
              //   ),
              // ),
            ],
          );
        }),
      ),
    );
  }
}
