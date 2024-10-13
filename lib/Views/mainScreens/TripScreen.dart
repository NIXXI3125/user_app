import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:users_app_cracon/Controller/assistants/assistant_methods.dart';
import 'package:users_app_cracon/Controller/global/global.dart';
import 'package:users_app_cracon/Controller/providers/landingScreenProvider.dart';
import 'package:users_app_cracon/Controller/providers/mainScreenProvider.dart';
import 'package:users_app_cracon/Views/Screens/LandingScreens/landingScreen.dart';
import 'package:users_app_cracon/Views/mainScreens/main_screen.dart';
import 'package:users_app_cracon/Views/widgets/progress_dialog.dart';
import 'package:users_app_cracon/models/rideDetailsModel.dart';

class Tripscreen extends StatefulWidget {
  const Tripscreen(
      {super.key, required this.rideRequestId, required this.driverId});
  final String rideRequestId;
  final String driverId;

  @override
  State<Tripscreen> createState() => _TripscreenState();
}

class _TripscreenState extends State<Tripscreen> {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  String rideId = '';
  Set<Marker> setOfMarkers = Set<Marker>();
  Set<Circle> setOfCircle = Set<Circle>();
  Set<Polyline> setOfPolyline = Set<Polyline>();
  List<LatLng> polyLinePositionCoordinates = [];
  GoogleMapController? newTripGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  StreamSubscription<Position>? streamSubscriptionDriverLivePosition;
  CameraPosition newDriverCamera = _kGooglePlex;
  Position? driverCurrentPosition;
  String? userEmail;
  double Distance = 0.0;
  double mapPadding = 0;
  RideRequest? rideRequest;
  String rideStatus = '';
  String previousData = '';
  StreamSubscription subscription =
      FirebaseDatabase.instance.ref().child("dummy").onValue.listen((event) {});
  Future<void> drawPolyLineFromOriginToDestination(
      LatLng originLatLng, LatLng destinationLatLng) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: "Please wait...",
      ),
    );

    var directionDetailsInfo =
        await AssistantMethods.obtainOriginToDestinationDirectionDetails(
            originLatLng, destinationLatLng);

    Navigator.pop(context);

    print("These are points = ");
    print(directionDetailsInfo!.e_points);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResultList =
        pPoints.decodePolyline(directionDetailsInfo!.e_points!);

    polyLinePositionCoordinates.clear();

    if (decodedPolyLinePointsResultList.isNotEmpty) {
      decodedPolyLinePointsResultList.forEach((PointLatLng pointLatLng) {
        polyLinePositionCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    setOfPolyline.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.purpleAccent,
        polylineId: const PolylineId("PolylineID"),
        jointType: JointType.round,
        points: polyLinePositionCoordinates,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      setOfPolyline.add(polyline);
    });

    LatLngBounds boundsLatLng;
    if (originLatLng.latitude > destinationLatLng.latitude &&
        originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng =
          LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    } else if (originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude),
      );
    } else if (originLatLng.latitude > destinationLatLng.latitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
        northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      boundsLatLng =
          LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }

    newTripGoogleMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));

    Marker originMarker = Marker(
      markerId: const MarkerId("originID"),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      setOfMarkers.add(originMarker);
      setOfMarkers.add(destinationMarker);
    });

    Circle originCircle = Circle(
      circleId: const CircleId("originID"),
      fillColor: Colors.green,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: originLatLng,
    );

    Circle destinationCircle = Circle(
      circleId: const CircleId("destinationID"),
      fillColor: Colors.red,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: destinationLatLng,
    );

    setState(() {
      setOfCircle.add(originCircle);
      setOfCircle.add(destinationCircle);
    });
  }

// getDriversLocationUpdatesAtRealTime() {
//     LatLng oldLatLng = LatLng(0, 0);

//     streamSubscriptionDriverLivePosition =
//         Geolocator.getPositionStream().listen((Position position) {
//       driverCurrentPosition = position;
//       newDriverCamera =
//           CameraPosition(target: LatLng(position.latitude, position.longitude));
//       Distance = Geolocator.distanceBetween(
//           position.latitude,
//           position.longitude,
//           widget.userRideRequestDetails!.originLatLng!.latitude,
//           widget.userRideRequestDetails!.originLatLng!.longitude);
//       print('distance:' + Distance.toString());
//       LatLng latLngLiveDriverPosition = LatLng(
//         onlineDriverCurrentPosition!.latitude,
//         onlineDriverCurrentPosition!.longitude,
//       );

//       Marker animatingMarker = Marker(
//         markerId: const MarkerId("AnimatedMarker"),
//         position: latLngLiveDriverPosition,
//         icon: iconAnimatedMarker!,
//         infoWindow: const InfoWindow(title: "This is your Position"),
//       );

//       setState(() {
//         CameraPosition cameraPosition =
//             CameraPosition(target: latLngLiveDriverPosition, zoom: 16);
//         newTripGoogleMapController!
//             .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

//         setOfMarkers.removeWhere(
//             (element) => element.markerId.value == "AnimatedMarker");
//         setOfMarkers.add(animatingMarker);
//       });

//       oldLatLng = latLngLiveDriverPosition;
//       updateDurationTimeAtRealTime();

//       //updating driver location at real time in Database
//       Map driverLatLngDataMap = {
//         "latitude": onlineDriverCurrentPosition!.latitude.toString(),
//         "longitude": onlineDriverCurrentPosition!.longitude.toString(),
//       };
//       FirebaseDatabase.instance
//           .ref()
//           .child("All Ride Requests")
//           .child(widget.userRideRequestDetails!.rideRequestId!)
//           .child("driverLocation")
//           .set(driverLatLngDataMap);
//     });
//   }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(
      const Duration(seconds: 1),
      () async {
        DatabaseEvent data = await fbase
            .child('All Ride Requests/${widget.rideRequestId}')
            .once();
        print('Ride Request Data: ${data.snapshot.value}');
        setState(() {
          rideId = widget.rideRequestId;
          rideRequest = RideRequest.fromMap(data.snapshot.value);
        });
        fbase.child('All Ride Requests/rideId/status').onValue.listen((value) {
          setState(() {
            rideStatus = value.snapshot.value.toString();
            print('Ride Status: ${rideStatus}');
          });
        });
      },
    );
  }

  getRideStatus() {
    subscription =
        fbase.child('All Ride Requests/$rideId/status').onValue.listen(
      (value) {
        String newData = value.snapshot.value.toString();
        if (previousData == '' || previousData != newData) {
          previousData = newData;
          setState(() {
            rideStatus = value.snapshot.value.toString();
            print('Ride Status: ${rideStatus}');
          });
          if (rideStatus == 'ended') {
            subscription.cancel();
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text('Your Trip is Ended!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            CupertinoPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                    create: (context) =>
                                        Landingscreenprovider(),
                                    child: LandingScreen())),
                            (route) => false);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        }
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    getRideStatus();
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return MainScreen();
        }), (route) => false);
        return false;
      },
      child: Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            GoogleMap(
              padding: EdgeInsets.only(bottom: mapPadding),
              mapType: MapType.normal,
              myLocationEnabled: true,
              initialCameraPosition: _kGooglePlex,
              markers: setOfMarkers,
              circles: setOfCircle,
              polylines: setOfPolyline,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newTripGoogleMapController = controller;
                newTripGoogleMapController!.setMapStyle('''
                    [
                      {
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "featureType": "administrative.locality",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#263c3f"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#6b9a76"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#38414e"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#212a37"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#9ca5b3"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#1f2835"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#f3d19c"
                          }
                        ]
                      },
                      {
                        "featureType": "transit",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#2f3948"
                          }
                        ]
                      },
                      {
                        "featureType": "transit.station",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#515c6d"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      }
                    ]
                ''');
                setState(() {
                  mapPadding = 350;
                });

                // var driverCurrentLatLng = LatLng(
                //     driverCurrentPosition!.latitude,
                //     driverCurrentPosition!.longitude);

                var userPickUpLatLng = LatLng(rideRequest?.origin['latitude'],
                    rideRequest?.origin['longitude']);

                var userDestinationLatLng = LatLng(
                    rideRequest?.destination['latitude'],
                    rideRequest?.destination['longitude']);

                drawPolyLineFromOriginToDestination(
                    userPickUpLatLng, userDestinationLatLng);

                // getDriversLocationUpdatesAtRealTime();
              },
            ),
            Container(
              height: _height * 0.5,
              width: double.infinity,
              color: const Color(0xFFFF914D),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.grey.shade100,
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 50,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border:
                                  Border.all(width: 2, color: Colors.blueGrey),
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.blueGrey,
                              size: 40,
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                rideRequest!.driverName ?? '',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(rideRequest!.carDetails ?? ''),
                            ],
                          ),
                          Expanded(child: Container()),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                            child: IconButton(
                              onPressed: () {
                                launchUrl(Uri(
                                  scheme: 'tel',
                                  path: rideRequest!.driverPhone,
                                ));
                              },
                              icon: const Icon(
                                Icons.call,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Fare: ₹ ${rideRequest!.fareAmount.toString().replaceAll("₹ ₹ ", '')}',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: const Color.fromRGBO(245, 245, 245, 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pickup Details: ',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                              Text(
                                'Person Name',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                              Text(
                                'Person Contact',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                              Text(
                                'Pickup Address',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                              Text(
                                rideRequest!.pickupDetails['name'] ?? '',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              Text(
                                rideRequest!.pickupDetails['phoneNo'] ?? '',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              Text(
                                rideRequest!.pickupDetails['address'] ?? '',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: const Color.fromRGBO(245, 245, 245, 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Drop Details: ',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                              Text(
                                'Person Name',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                              Text(
                                'Person Contact',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                              Text(
                                'Drop Address',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                              Text(
                                rideRequest!.dropDetails['name'] ?? '',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              Text(
                                rideRequest!.dropDetails['phoneNo'] ?? '',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              Text(
                                rideRequest!.dropDetails['address'] ?? '',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        fbase
                            .child('All Ride Requests/${widget.rideRequestId}')
                            .update({
                          'status': 'cancelled',
                          'driverId': widget.driverId,
                        });
                        fbase.child('drivers/${widget.driverId}').update({
                          'newRideRequest': 'cancelled',
                          'rideRequestStatus': "idle",
                        });
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (context) {
                          return ChangeNotifierProvider(
                              create: (context) => Mainscreenprovider(),
                              child: MainScreen());
                        }), (route) => false);
                      },
                      child: const Text('Cancel Trip'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
