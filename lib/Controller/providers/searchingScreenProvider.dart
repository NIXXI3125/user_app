import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:users_app_cracon/Controller/assistants/push_notification.dart';
import 'package:users_app_cracon/Controller/global/global.dart';
import 'package:users_app_cracon/Controller/infoHandler/app_info.dart';
import 'package:users_app_cracon/Views/mainScreens/TripScreen.dart';
import 'package:users_app_cracon/models/active_nearby_available_drivers.dart';

enum Searchingscreenstate { initial, loading, loaded, error }

class Searchingscreenprovider extends ChangeNotifier {
  Searchingscreenstate state = Searchingscreenstate.initial;
  List<double> kms = List.generate(5, (index) => (index + 1));
  List<ActiveNearbyAvailableDrivers> onlineDrivers = [];
  List<Map<String, dynamic>> driverswithDistance = [];
  List<Map<String, dynamic>> driverswithrangedDistance = [];
  DatabaseReference? referenceRideRequest;
  StreamController<String> rideRequestStreamController =
      StreamController<String>();
  void currentonlinedrivers(BuildContext context, String cost) async {
    DatabaseEvent drivers = await fbase.child('activeDrivers').once();
    if (drivers.snapshot.value != null) {
      print('Current Drivers ${drivers.snapshot.value}');
      Map<dynamic, dynamic> data =
          drivers.snapshot.value as Map<dynamic, dynamic>;
      onlineDrivers = data.entries.map((entry) {
        Map<String, dynamic> drivers = Map<String, dynamic>.from(entry.value);
        return ActiveNearbyAvailableDrivers.fromJson(
          entry.key,
          drivers,
        );
      }).toList();
      print('Online Drivers: $onlineDrivers');
    }
    onlineDrivers.forEach((element) {
      driverswithDistance.add({
        'id': element.driverId,
        'distance': distanceBetweenUserandDriverinKms(
          driverlatitude: element.locationLatitude!,
          driverlongitude: element.locationLongitude!,
        ),
      });
    });
    driversnearby(5, cost, context);
    notifyListeners();
    print('distance of drivers $driverswithDistance');
  }

  double distanceBetweenUserandDriverinKms(
      {required double driverlatitude, required double driverlongitude}) {
    double distanceinmeters = Geolocator.distanceBetween(
        userPickupLocationLatitude!,
        userPickupLocationLongitude!,
        driverlatitude,
        driverlongitude);
    return (distanceinmeters / 1000);
  }

  void driversnearby(double range, String cost, BuildContext context) async {
    driverswithrangedDistance =
        driverswithDistance.where((item) => item['distance'] < range).toList();
    print('Drivers within $range kms: $driverswithrangedDistance');
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
      "pickupDetails": pickupDetails.toMap(),
      "dropDetails": dropDetails.toMap(),
      "user_cost": cost,
    };
    referenceRideRequest =
        FirebaseDatabase.instance.ref().child("All Ride Requests").push();
    referenceRideRequest!.set(userInformationMap);
    driverswithrangedDistance.forEach((element) {
      sendNotificationtoDriver(chosenDriverId: element['id'], context: context);
    });
    notifyListeners();
  }

  void sendNotificationtoDriver(
      {required String chosenDriverId, required BuildContext context}) async {
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
    getRideRequestStream(context, referenceRideRequest!.key.toString());
  }

  StreamSubscription getRideRequestStream(
      BuildContext context, String rideRequestId,
      {int timeout = 120}) {
    StreamSubscription subscription = FirebaseDatabase.instance
        .ref()
        .child("dummy")
        .onValue
        .listen((event) {});
    subscription = FirebaseDatabase.instance
        .ref()
        .child("All Ride Requests")
        .child(rideRequestId)
        .onValue
        .listen(
      (event) {
        var data = event.snapshot.value;
        if (data != null) {
          if ((data as Map)['driverId'] != "waiting") {
            Fluttertoast.showToast(msg: "Driver Accepted the Ride Request.");
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => Tripscreen(
                  rideRequestId: rideRequestId,
                  driverId: data['driverId'],
                ),
              ),
              (route) => false,
            );
            subscription.cancel();
            notifyListeners();
          }
        }
        if (data == null) {
          Fluttertoast.showToast(msg: "Driver Rejected the Ride Request.");
          subscription.cancel();
          notifyListeners();
        }
      },
    );
    Timer(Duration(seconds: timeout), () {
      subscription.cancel();
      referenceRideRequest!.remove();
      referenceRideRequest = null;
      notifyListeners();
    });
    return subscription;
  }
}
