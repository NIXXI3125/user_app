import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:users_app_cracon/Controller/assistants/assistant_methods.dart';
import 'package:users_app_cracon/Controller/assistants/geofire_assistant.dart';
import 'package:users_app_cracon/Controller/assistants/push_notification.dart';
import 'package:users_app_cracon/Controller/global/global.dart';
import 'package:users_app_cracon/Controller/infoHandler/app_info.dart';
import 'package:users_app_cracon/Controller/providers/mainScreenProvider.dart';
import 'package:users_app_cracon/Controller/providers/vehiclesListProvider.dart';
import 'package:users_app_cracon/Views/mainScreens/search_places_screen.dart';
import 'package:users_app_cracon/Views/mainScreens/search_places_screen_tu.dart';
import 'package:users_app_cracon/Views/mainScreens/select_nearest_active_driver_screen.dart';
import 'package:users_app_cracon/Views/mainScreens/vehicles_list.dart';
import 'package:users_app_cracon/Views/widgets/BottomModalSheet.dart';
import 'package:users_app_cracon/Views/widgets/dottedLine.dart';
import 'package:users_app_cracon/models/active_nearby_available_drivers.dart';
import 'package:users_app_cracon/Views/widgets/my_drawer.dart';
import 'package:users_app_cracon/Views/widgets/progress_dialog.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  double searchLocationContainerHeight = 220;

  Position? userCurrentPosition;
  var geoLocator = Geolocator();
  LayerLink _link = LayerLink();
  LocationPermission? _locationPermission;
  double bottomPaddingOfMap = 0;

  List<LatLng> pLineCoOrdinatesList = [];
  Set<Polyline> polyLineSet = {};
  Set<Marker> markersSet = {};
  Set<Circle> circleSet = {};

  String userName = "Your Name";
  String userEmail = "Your Email";
  TextEditingController pickupcontroller = TextEditingController();
  TextEditingController dropcontroller = TextEditingController();
  bool openNavigationDrawer = true;
  bool _isHeight = false;
  bool isVisible = true;
  bool activeNearbyDriverKeysLoaded = false;
  BitmapDescriptor? activeNearbyIcon;

  List<ActiveNearbyAvailableDrivers> onlineNearByAvailableDriversList = [];

  DatabaseReference? referenceRideRequest;

  blackThemeGoogleMap() {
    newGoogleMapController!.setMapStyle('''
                    [
                      {
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#f5f5f5"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#616161"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#f5f5f5"
                          }
                        ]
                      },
                      {
                        "featureType": "administrative.locality",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#757575"
                          }
                        ]
                      },
                      {
                        "featureType": "poi",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#757575"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#e5e5e5"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#9e9e9e"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#ffffff"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#e0e0e0"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#9e9e9e"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#dadada"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#c9c9c9"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#616161"
                          }
                        ]
                      },
                      {
                        "featureType": "transit",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#e5e5e5"
                          }
                        ]
                      },
                      {
                        "featureType": "transit.station",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#757575"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#c9c9c9"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#9e9e9e"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#ffffff"
                          }
                        ]
                      }
                    ]
                ''');
  }

  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition =
        LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    userName = userModelCurrentInfo!.name!;
    userEmail = userModelCurrentInfo!.email!;

    initializeGeoFireListener();
  }

  @override
  void initState() {
    super.initState();
    checkIfLocationPermissionAllowed();
  }

  saveRideRequestInformation() {
    // SAVE RIDE REQUEST INFORMATION
    referenceRideRequest =
        FirebaseDatabase.instance.ref().child("All Ride Requests").push();

    var originLocation =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationLocation =
        Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    Map originLocationMap = {
      "latitude": originLocation!.locationLatitude.toString(),
      "longitude": originLocation!.locationLongitude.toString(),
    };

    Map destinationLocationMap = {
      "latitude": destinationLocation!.locationLatitude.toString(),
      "longitude": destinationLocation!.locationLongitude.toString(),
    };

    Map userInformationMap = {
      "origin": originLocationMap,
      "destination": destinationLocationMap,
      "time": DateTime.now().toString(),
      "userName": userModelCurrentInfo!.name,
      "userPhone": userModelCurrentInfo!.phone,
      "originAddress": originLocation.locationName,
      "destinationAddress": destinationLocation.locationName,
      "driverId": "waiting",
    };

    referenceRideRequest!.set(userInformationMap);

    onlineNearByAvailableDriversList =
        GeoFireAssistant.activeNearbyAvailableDriversList;
    searchNearestOnlineDrivers();
  }

  searchNearestOnlineDrivers() async {
    // WHEN NO ACTIVE DRIVER AVAILABLE
    if (onlineNearByAvailableDriversList.length == 0) {
      // CANCEL RIDE REQUEST
      referenceRideRequest!.remove();

      setState(() {
        polyLineSet.clear();
        markersSet.clear();
        circleSet.clear();
        pLineCoOrdinatesList.clear();
      });

      Fluttertoast.showToast(
          msg:
              "No Online Nearest Driver Available. Search Again After Some Time, Restarting App Now");

      return;
    }

    // WHEN ACTIVE DRIVER4 AVAILABLE
    await retrieveOnlineDriversInformation(onlineNearByAvailableDriversList);

    var response = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (c) => ChangeNotifierProvider(
                create: (context) => Vehicleslistprovider(),
                child: VehiclesList(),
              )

          // SelectNearestActiveDriversScreen(
          //     referenceRideRequest: referenceRideRequest)
          ),
    );

    if (response == "driverChoosed") {
      FirebaseDatabase.instance
          .ref()
          .child("drivers")
          .child(chosenDriverId!)
          .once()
          .then((snap) {
        if (snap.snapshot.value != null) {
          // SEND NOTIFICATION TO DRIVER
          sendNotificationToDriverNow(chosenDriverId!);
        } else {
          Fluttertoast.showToast(
              msg: "This Driver Do Not Exist.Try Another Driver");
        }
      });
    }
  }

  sendNotificationToDriverNow(String chosenDriverId) {
    // ASSIGN RIDE REQUEST ID TO NEW RIDE STATUS
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(chosenDriverId)
        .child("newRideRequest")
        .set(referenceRideRequest!.key);

    // AUTOMATE PUSH NOTIFICATION
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(chosenDriverId)
        .child("token")
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        String deviceRegistrationToken = snap.snapshot.value.toString();

        PushNotification.sendNotificationToSelectedDriver(
            deviceRegistrationToken,
            referenceRideRequest!.key.toString(),
            context);
      } else {
        Fluttertoast.showToast(msg: "Please choose another driver.");
        return;
      }
    });
  }

  retrieveOnlineDriversInformation(List onlineNearestDriversList) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child("drivers");
    for (int i = 0; i < onlineNearestDriversList.length; i++) {
      await ref
          .child(onlineNearestDriversList[i].driverId.toString())
          .once()
          .then((dataSnapshot) {
        var driverKeyInfo = dataSnapshot.snapshot.value;
        dList.add(driverKeyInfo);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    createActiveNearByDriverIconMarker();

    final double _height = MediaQuery.of(context).size.height;
    final double _width = MediaQuery.of(context).size.width;
    return SafeArea(
      top: false,
      child:
          Consumer<Mainscreenprovider>(builder: (context, screenprovider, _) {
        return Scaffold(
          key: sKey,
          drawer: Container(
            width: 265,
            child: Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Colors.black,
              ),
              child: MyDrawer(
                name: userName,
                email: userEmail,
              ),
            ),
          ),
          appBar: PreferredSize(
            preferredSize: Size(_width, _height * 0.3),
            child: Container(
              padding: const EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFFFF914D),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      var responseFromSearchScreenTu = Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => SearchPlacesScreenTu()));

                      if (responseFromSearchScreenTu == "obtainedPickup") {}
                    },
                    child: Container(
                      height: _height * 0.055,
                      width: _width * 0.9,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 2),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle_outlined,
                            color: Color(0xFFFF914D),
                            size: 25,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            Provider.of<AppInfo>(context).userPickUpLocation !=
                                    null
                                ? Provider.of<AppInfo>(context)
                                    .userPickUpLocation!
                                    .locationName!
                                : "What is the Pickup Location? ",
                            style: TextStyle(
                              color: (Provider.of<AppInfo>(context)
                                          .userPickUpLocation !=
                                      null)
                                  ? Colors.black
                                  : Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      // TextField(
                      //   controller: pickupcontroller,
                      //   // onChanged: (value) {},
                      //   onTap: () {
                      //     var responseFromSearchScreenTu = Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (c) => SearchPlacesScreenTu()));

                      //     if (responseFromSearchScreenTu == "obtainedPickup") {}
                      //   },
                      //   decoration: const InputDecoration(
                      //     hintText: 'Pickup Location',
                      //     border: InputBorder.none,
                      //     errorBorder: InputBorder.none,
                      //     disabledBorder: InputBorder.none,
                      //     enabledBorder: InputBorder.none,
                      //     prefixIcon: Icon(
                      //       Icons.circle_outlined,
                      //       color: Color(0xFFFF914D),
                      //       size: 25,
                      //     ),
                      //   ),
                      // ),
                    ),
                  ),
                  SizedBox(
                    height: _height * 0.035,
                  ),
                  GestureDetector(
                    onTap: () async {
                      var responseFromSearchScreen = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => SearchPlacesScreen(),
                        ),
                      );

                      if (responseFromSearchScreen == "obtainedDropOff") {
                        setState(
                          () {
                            openNavigationDrawer = false;
                          },
                        );

                        await drawPolyLineFromOriginToDestination();
                      }
                    },
                    child: Container(
                      height: _height * 0.055,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 2),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Color(0xFFFF914D),
                            size: 25,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            Provider.of<AppInfo>(context).userDropOffLocation !=
                                    null
                                ? Provider.of<AppInfo>(context)
                                    .userDropOffLocation!
                                    .locationName!
                                : "What is the Drop Location? ",
                            style: TextStyle(
                              color: (Provider.of<AppInfo>(context)
                                          .userDropOffLocation !=
                                      null)
                                  ? Colors.black
                                  : Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      // TextField(
                      //   controller: dropcontroller,
                      //   onChanged: (value) async {
                      //     await screenprovider.getDropLocation(value);
                      //     print("drop locations:" +
                      //         screenprovider.dropLocationList.toString());
                      //   },
                      //   onTap: () async {
                      //     // go to search places screen
                      //   },
                      //   decoration: const InputDecoration(
                      //     hintText: 'Drop Location',
                      //     border: InputBorder.none,
                      //     errorBorder: InputBorder.none,
                      //     disabledBorder: InputBorder.none,
                      //     enabledBorder: InputBorder.none,
                      //     prefixIcon: Icon(
                      //       Icons.location_on,
                      //       color: Color(0xFFFF914D),
                      //       size: 25,
                      //     ),
                      //   ),
                      // ),
                    ),
                  ),
                  SizedBox(
                    height: _height * 0.02,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    iconAlignment: IconAlignment.end,
                    label: const Text(
                      "Request Ride",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (Provider.of<AppInfo>(context, listen: false)
                              .userDropOffLocation !=
                          null) {
                        saveRideRequestInformation();
                      } else {
                        Fluttertoast.showToast(
                            msg: "Please Select Destination Location");
                      }
                      setState(() {
                        isVisible = !isVisible;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: _height * 0.02,
                  ),
                ],
              ),
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: _height * 0.664,
                width: _width,
                child: GoogleMap(
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: true,
                  initialCameraPosition: _kGooglePlex,
                  polylines: polyLineSet,
                  markers: markersSet,
                  circles: circleSet,
                  onMapCreated: (GoogleMapController controller) {
                    _controllerGoogleMap.complete(controller);
                    newGoogleMapController = controller;

                    //for black theme google map
                    blackThemeGoogleMap();

                    locateUserPosition();
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Future<void> drawPolyLineFromOriginToDestination() async {
    var originPosition =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationPosition =
        Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    var originLatLng = LatLng(
        originPosition!.locationLatitude!, originPosition.locationLongitude!);
    var destinationLatLng = LatLng(destinationPosition!.locationLatitude!,
        destinationPosition.locationLongitude!);

    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: "Please wait...",
      ),
    );

    var directionDetailsInfo =
        await AssistantMethods.obtainOriginToDestinationDirectionDetails(
            originLatLng, destinationLatLng);

    setState(() {
      tripDirectionDetailsInfo = directionDetailsInfo;
    });

    Navigator.pop(context);

    print("These are Points = ");
    print(directionDetailsInfo!.e_points);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResultList =
        pPoints.decodePolyline(directionDetailsInfo.e_points!);

    pLineCoOrdinatesList.clear();

    if (decodedPolyLinePointsResultList.isNotEmpty) {
      decodedPolyLinePointsResultList.forEach((PointLatLng pointLatLng) {
        pLineCoOrdinatesList
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polyLineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.green,
        polylineId: const PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLineCoOrdinatesList,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polyLineSet.add(polyline);
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

    newGoogleMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));

    Marker originMarker = Marker(
        markerId: const MarkerId("originID"),
        infoWindow:
            InfoWindow(title: originPosition.locationName, snippet: "Origin"),
        position: originLatLng,
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow));

    Marker destinationMarker = Marker(
        markerId: const MarkerId("destinationID"),
        infoWindow: InfoWindow(
            title: destinationPosition.locationName, snippet: "Destination"),
        position: destinationLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));

    setState(() {
      markersSet.add(originMarker);
      markersSet.add(destinationMarker);
    });

    Circle originCircle = Circle(
      circleId: const CircleId("originID"),
      fillColor: Colors.lightGreen,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: originLatLng,
    );

    Circle destinationCircle = Circle(
      circleId: const CircleId("destinationID"),
      fillColor: Colors.redAccent,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: destinationLatLng,
    );

    setState(() {
      circleSet.add(originCircle);
      circleSet.add(destinationCircle);
    });
  }

  initializeGeoFireListener() {
    Geofire.initialize("activeDrivers");

    Geofire.queryAtLocation(
            userCurrentPosition!.latitude, userCurrentPosition!.longitude, 10)!
        .listen((map) {
      print(map);
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
          // whenever any driver become active
          case Geofire.onKeyEntered:
            ActiveNearbyAvailableDrivers activeNearbyAvailableDriver =
                ActiveNearbyAvailableDrivers();
            activeNearbyAvailableDriver.locationLatitude = map['latitude'];
            activeNearbyAvailableDriver.locationLongitude = map['longitude'];
            activeNearbyAvailableDriver.driverId = map['key'];
            GeoFireAssistant.activeNearbyAvailableDriversList
                .add(activeNearbyAvailableDriver);
            if (activeNearbyDriverKeysLoaded == true) {
              displayActiveDriversOnUsersMap();
            }
            break;

          // whenever any driver become active
          case Geofire.onKeyExited:
            GeoFireAssistant.deleteOfflineDriverFromList(map['key']);
            break;

          case Geofire.onKeyMoved:
            ActiveNearbyAvailableDrivers activeNearbyAvailableDriver =
                ActiveNearbyAvailableDrivers();
            activeNearbyAvailableDriver.locationLatitude = map['latitude'];
            activeNearbyAvailableDriver.locationLongitude = map['longitude'];
            activeNearbyAvailableDriver.driverId = map['key'];
            GeoFireAssistant.updateActiveNearbyAvailableDriverLocation(
                activeNearbyAvailableDriver);
            displayActiveDriversOnUsersMap();
            break;

          // DISPLAY THOSE ONLINE AND ACTIVE DRIVERS ON USERS MAP
          case Geofire.onGeoQueryReady:
            activeNearbyDriverKeysLoaded = true;
            displayActiveDriversOnUsersMap();
            break;
        }
      }

      setState(() {});
    });
  }

  displayActiveDriversOnUsersMap() {
    setState(() {
      markersSet.clear();
      circleSet.clear();

      Set<Marker> driversMarkerSet = Set<Marker>();

      for (ActiveNearbyAvailableDrivers eachDriver
          in GeoFireAssistant.activeNearbyAvailableDriversList) {
        LatLng eachDriverActivePosition =
            LatLng(eachDriver.locationLatitude!, eachDriver.locationLongitude!);

        Marker marker = Marker(
          markerId: MarkerId(eachDriver.driverId!),
          position: eachDriverActivePosition,
          icon: activeNearbyIcon!,
          rotation: 360,
        );

        driversMarkerSet.add(marker);
      }

      setState(() {
        markersSet = driversMarkerSet;
      });
    });
  }

  createActiveNearByDriverIconMarker() {
    if (activeNearbyIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size(2, 2));
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, "android/images/car.png")
          .then((value) {
        activeNearbyIcon = value;
      });
    }
  }
}

// GoogleMap(
//   mapType: MapType.normal,
//   myLocationEnabled: true,
//   zoomGesturesEnabled: true,
//   zoomControlsEnabled: true,
//   initialCameraPosition: _kGooglePlex,
//   polylines: polyLineSet,
//   markers: markersSet,
//   circles: circleSet,
//   onMapCreated: (GoogleMapController controller) {
//     _controllerGoogleMap.complete(controller);
//     newGoogleMapController = controller;

//     //for black theme google map
//     blackThemeGoogleMap();

//     locateUserPosition();
//   },
// ),

// GestureDetector(
//                             onTap: () async {
//                               // search places screen for pickup
//                               var responseFromSearchScreenTu = Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (c) => SearchPlacesScreenTu()));

//                               if (responseFromSearchScreenTu ==
//                                   "obtainedPickup") {}
//                             },
//                             child: Row(
//                               children: [
//                                 const Icon(
//                                   Icons.add_location_alt_outlined,
//                                   color: Colors.black,
//                                 ),
//                                 const SizedBox(
//                                   width: 12.0,
//                                 ),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const Text(
//                                       "From",
//                                       style: TextStyle(
//                                           color: Colors.black, fontSize: 12),
//                                     ),
//                                     Text(
//                                       Provider.of<AppInfo>(context)
//                                                   .userPickUpLocation !=
//                                               null
//                                           ? Provider.of<AppInfo>(context)
//                                               .userPickUpLocation!
//                                               .locationName!
//                                           : "your current location",
//                                       style: const TextStyle(
//                                           color: Colors.black, fontSize: 14),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),

//                           const SizedBox(height: 10.0),

//                           const Divider(
//                             height: 1,
//                             thickness: 1,
//                             color: Colors.black,
//                           ),

//                           const SizedBox(height: 16.0),

//                           //to
//                           GestureDetector(
//                             onTap: () async {
//                               // go to search places screen
//                               var responseFromSearchScreen =
//                                   await Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (c) => SearchPlacesScreen(),
//                                 ),
//                               );

//                               if (responseFromSearchScreen ==
//                                   "obtainedDropOff") {
//                                 setState(
//                                   () {
//                                     openNavigationDrawer = false;
//                                   },
//                                 );

//                                 await drawPolyLineFromOriginToDestination();
//                               }
//                             },
//                             child: Row(
//                               children: [
//                                 const Icon(
//                                   Icons.add_location_alt_outlined,
//                                   color: Colors.black,
//                                 ),
//                                 const SizedBox(
//                                   width: 12.0,
//                                 ),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const Text(
//                                       "To",
//                                       style: TextStyle(
//                                           color: Colors.black, fontSize: 12),
//                                     ),
//                                     Text(
//                                       Provider.of<AppInfo>(context)
//                                                   .userDropOffLocation !=
//                                               null
//                                           ? Provider.of<AppInfo>(context)
//                                               .userDropOffLocation!
//                                               .locationName!
//                                           : "Where to go?",
//                                       style: const TextStyle(
//                                           color: Colors.black, fontSize: 14),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),

//                           const SizedBox(height: 10.0),

//                           const Divider(
//                             height: 1,
//                             thickness: 1,
//                             color: Colors.black,
//                           ),

//                           const SizedBox(height: 16.0),

//                           ElevatedButton(
//                             child: const Text(
//                               "Request Ride",
//                               style: TextStyle(color: Colors.white),
//                             ),
//                             onPressed: () {
//                               if (Provider.of<AppInfo>(context, listen: false)
//                                       .userDropOffLocation !=
//                                   null) {
//                                 saveRideRequestInformation();
//                               } else {
//                                 Fluttertoast.showToast(
//                                     msg: "Please Select Destination Location");
//                               }
//                             },
//                             style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.green,
//                                 textStyle: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white)),
//                           ),
