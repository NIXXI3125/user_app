import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:users_app_cracon/Controller/global/global.dart';
import 'package:users_app_cracon/models/active_nearby_available_drivers.dart';

enum Searchingscreenstate { initial, loading, loaded, error }

class Searchingscreenprovider extends ChangeNotifier {
  Searchingscreenstate state = Searchingscreenstate.initial;
  List<double> kms = List.generate(5, (index) => (index + 1));
  List<ActiveNearbyAvailableDrivers> onlineDrivers = [];
  List<Map<String, dynamic>>? driverswithDistance;
  void currentonlinedrivers() async {
    DatabaseEvent drivers = await fbase.child('activeDrivers').once();
    if (drivers.snapshot.value != null) {
      print('Current Drivers ${drivers.snapshot.value}');
      Map<dynamic, dynamic> data =
          drivers.snapshot.value as Map<dynamic, dynamic>;
      onlineDrivers = data.entries.map((entry) {
        Map<String, dynamic> drivers = Map<String, dynamic>.from(entry.value);
        return ActiveNearbyAvailableDrivers.fromJson(entry.key, drivers);
      }).toList();
      print('Online Drivers: $onlineDrivers');
    }
    driversnearby(2);
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

  void driversnearby(double range) async {
    onlineDrivers.forEach((driver) {
      double distance = distanceBetweenUserandDriverinKms(
        driverlatitude: driver.locationLatitude!,
        driverlongitude: driver.locationLongitude!,
      );
      if (distance <= range) {
        driverswithDistance?.add({
          'id': driver.driverId,
          'distance': distance,
        });
      }
    });
    notifyListeners();

    print('distance of drivers $driverswithDistance');
  }
}
