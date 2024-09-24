import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:users_app_cracon/models/DeliveryVehicleList.dart';
import 'package:users_app_cracon/models/FixedVehicleList.dart';
import 'package:users_app_cracon/models/HeavyVehicleList.dart';
import 'package:users_app_cracon/models/direction_details_info.dart';

import '../global/global.dart';

enum VehicleState {
  initial,
  loading,
  loaded,
  error,
}

class Vehicleslistprovider extends ChangeNotifier {
  List<HeavyVehicleType>? heavyvehicleList;
  List<DeliveryVehicle>? deliveryvehicleList;
  List<FixedVehicleType>? fixedvehicleList;
  Future<void> getHeavyVehiclesCost() async {
    DatabaseEvent vehiclesData = await fbase.child('Heavy_vehicles').once();
    if (vehiclesData.snapshot.value != null) {
      print('Vehicles Data' + vehiclesData.snapshot.value.toString());
      Map<dynamic, dynamic> data =
          vehiclesData.snapshot.value as Map<dynamic, dynamic>;
      heavyvehicleList = data.entries.map((entry) {
        Map<String, dynamic> vehicleData =
            Map<String, dynamic>.from(entry.value);
        return HeavyVehicleType.fromJson(vehicleData);
      }).toList();
      print(heavyvehicleList);
      notifyListeners();
    }
    // print('Vehicle Rates' + vehicleRates.toString());
  }

  Future<void> getDeliveryVehiclesCost() async {
    DatabaseEvent vehiclesData = await fbase.child('Globals').once();
    print('Vehicles Data' + vehiclesData.snapshot.value.toString());
    if (vehiclesData.snapshot.value != null) {
      print('Vehicles Data' + vehiclesData.snapshot.value.toString());
      Map<dynamic, dynamic> data =
          vehiclesData.snapshot.value as Map<dynamic, dynamic>;
      deliveryvehicleList = data.entries.map((entry) {
        Map<String, dynamic> vehicleData =
            Map<String, dynamic>.from(entry.value);
        return DeliveryVehicle.fromJson(vehicleData);
      }).toList();
      print(deliveryvehicleList);
      notifyListeners();
    }
    // print('Vehicle Rates' + vehicleRates.toString());
  }

  Future<void> getFixedVehiclesCost() async {
    DatabaseEvent vehiclesData = await fbase.child('fixed_vehicles').once();
    print('Vehicles Data' + vehiclesData.snapshot.value.toString());
    if (vehiclesData.snapshot.value != null) {
      print('Vehicles Data' + vehiclesData.snapshot.value.toString());
      Map<dynamic, dynamic> data =
          vehiclesData.snapshot.value as Map<dynamic, dynamic>;
      fixedvehicleList = data.entries.map((entry) {
        Map<String, dynamic> vehicleData =
            Map<String, dynamic>.from(entry.value);
        return FixedVehicleType.fromJson(vehicleData);
      }).toList();
      print(fixedvehicleList);
      notifyListeners();
    }
  }

  double calculateFareAmountFromOriginToDestination(
      {required DirectionDetailsInfo directionDetailsInfo,
      required DeliveryVehicle vehicle}) {
    double totalDistanceinkm =
        (directionDetailsInfo.distance_value! / 1000).truncateToDouble();
    print('total distance is: $totalDistanceinkm');
    double basekms = vehicle.baseDistance;
    double baseprice = vehicle.basePrice;
    double priceperkm = vehicle.perKm;
    if (totalDistanceinkm <= basekms) {
      return baseprice;
    }
    if (totalDistanceinkm > basekms) {
      double differencekms = (totalDistanceinkm - basekms);
      double cost = baseprice + (differencekms * priceperkm);
      return cost;
    } else {
      return 0.0;
    }
  }

  double calculateFareAmountForHeavyVehicles(
      {required DirectionDetailsInfo directionDetailsInfo,
      required HeavyVehicleType vehicle}) {
    return vehicle.hourlyPrice;
  }

  double calculateFareAmountForFixedVehicles(
      {required DirectionDetailsInfo directionDetailsInfo,
      required FixedVehicleType vehicle}) {
    return vehicle.Price;
  }
}
