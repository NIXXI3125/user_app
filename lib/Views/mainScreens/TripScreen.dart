import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:users_app_cracon/Controller/global/global.dart';
import 'package:users_app_cracon/Controller/providers/mainScreenProvider.dart';
import 'package:users_app_cracon/Views/mainScreens/main_screen.dart';
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

  Set<Polyline> polyLineSet = {};
  Set<Marker> markersSet = {};
  Set<Circle> circleSet = {};
  String? userEmail;
  RideRequest? rideRequest;
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
        rideRequest = RideRequest.fromMap(data.snapshot.value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return MainScreen();
        }), (route) => false);
        return false;
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: _height * 0.6,
              width: double.infinity,
              color: const Color(0xFFFF914D).withOpacity(0.5),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Row(
                      children: [
                        Container(
                          height: 50,
                          padding: const EdgeInsets.all(8),
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
                          children: [
                            Text(rideRequest!.driverName ?? ''),
                            Text(rideRequest!.carDetails ?? ''),
                          ],
                        ),
                        Expanded(child: Container()),
                        IconButton(
                          onPressed: () {
                            launchUrl(Uri(
                              scheme: 'tel',
                              path: rideRequest!.driverPhone,
                            ));
                          },
                          icon: const Icon(Icons.call),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Origin Address: " + (rideRequest!.originAddress ?? ''),
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Destination Address: " +
                        (rideRequest!.destinationAddress ?? ''),
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Fare: ${rideRequest!.fareAmount}',
                    style: const TextStyle(
                      fontSize: 20,
                    ),
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
          ],
        ),
      ),
    );
  }
}
