import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:users_app_cracon/Controller/global/global.dart';
import 'package:users_app_cracon/models/PickupDetailsModel.dart';
import 'package:users_app_cracon/models/directions.dart';
import 'package:users_app_cracon/models/dropDetailModel.dart';

class AppInfo extends ChangeNotifier {
  Directions? userPickUpLocation, userDropOffLocation;
  Pickupdetailsmodel? pickup;
  Dropdetailsmodel? drop;

  void updatePickUpLocationAddress(Directions userPickUpAddress) {
    userPickupLocationLatitude = userPickUpAddress.locationLatitude;
    userPickupLocationLongitude = userPickUpAddress.locationLongitude;
    userPickUpLocation = userPickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Directions dropOffAddress) {
    userDropLocationLatitude = dropOffAddress.locationLatitude;
    userDropLocationLongitude = dropOffAddress.locationLongitude;
    userDropOffLocation = dropOffAddress;
    notifyListeners();
  }

  void userPickUpDetails(Pickupdetailsmodel pickup) {
    pickup = pickup;
    notifyListeners();
    print('Pickup Details:' + pickup.name!);
  }

  void userDropDetails(Dropdetailsmodel drop) {
    drop = drop;
    notifyListeners();
    print('drop Details:' + drop.name!);
  }
}
