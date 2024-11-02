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

enum CostState {
  initial,
  loading,
  loaded,
  error,
}

class Vehicleslistprovider extends ChangeNotifier {
  VehicleState state = VehicleState.initial;
  CostState costState = CostState.initial;
  List<HeavyVehicleType>? heavyvehicleList;
  List<DeliveryVehicle>? deliveryvehicleList;
  List<FixedVehicleType>? fixedvehicleList;

  Future<void> getAllVehiclesCost() async {
    state = VehicleState.loading;
    getHeavyVehiclesCost();
    getDeliveryVehiclesCost();
    getFixedVehiclesCost();
    state = VehicleState.loaded;
    notifyListeners();
  }

  Future<void> getHeavyVehiclesCost() async {
    state = VehicleState.loading;
    DatabaseEvent vehiclesData = await fbase.child('Heavy_vehicles').once();
    if (vehiclesData.snapshot.value != null) {
      Map<dynamic, dynamic> data =
          vehiclesData.snapshot.value as Map<dynamic, dynamic>;
      heavyvehicleList = data.entries.map((entry) {
        Map<String, dynamic> vehicleData =
            Map<String, dynamic>.from(entry.value);
        return HeavyVehicleType.fromJson(vehicleData);
      }).toList();
      state = VehicleState.loaded;
      notifyListeners();
    }
  }

  Future<void> getDeliveryVehiclesCost() async {
    state = VehicleState.loading;
    DatabaseEvent vehiclesData = await fbase.child('Globals').once();
    if (vehiclesData.snapshot.value != null) {
      Map<dynamic, dynamic> data =
          vehiclesData.snapshot.value as Map<dynamic, dynamic>;
      deliveryvehicleList = data.entries.map((entry) {
        Map<String, dynamic> vehicleData =
            Map<String, dynamic>.from(entry.value);
        return DeliveryVehicle.fromJson(vehicleData);
      }).toList();
      print(deliveryvehicleList);
      state = VehicleState.loaded;
      notifyListeners();
    }
  }

  Future<void> getFixedVehiclesCost() async {
    state = VehicleState.loading;
    DatabaseEvent vehiclesData = await fbase.child('fixed_vehicles').once();
    if (vehiclesData.snapshot.value != null) {
      Map<dynamic, dynamic> data =
          vehiclesData.snapshot.value as Map<dynamic, dynamic>;
      fixedvehicleList = data.entries.map((entry) {
        Map<String, dynamic> vehicleData =
            Map<String, dynamic>.from(entry.value);
        return FixedVehicleType.fromJson(vehicleData);
      }).toList();
      state = VehicleState.loaded;
      notifyListeners();
    }
  }

  double calculateFareAmountFromOriginToDestination(
      {required DirectionDetailsInfo directionDetailsInfo,
      required DeliveryVehicle vehicle}) {
    costState = CostState.loading;
    double totalDistanceinkm =
        (directionDetailsInfo.distance_value! / 1000).truncateToDouble();
    double basekms = vehicle.baseDistance;
    double baseprice = vehicle.basePrice;
    double priceperkm = vehicle.perKm;
    double cost = 0.0;
    if (totalDistanceinkm <= basekms) {
      cost = baseprice;
    } else {
      double differencekms = (totalDistanceinkm - basekms);
      cost = baseprice + (differencekms * priceperkm);
    }
    return cost;
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
