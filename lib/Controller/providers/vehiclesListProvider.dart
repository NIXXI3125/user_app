import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:users_app_cracon/models/vehicleCostModel.dart';

import '../global/global.dart';

enum VehicleState {
  initial,
  loading,
  loaded,
  error,
}

class Vehicleslistprovider extends ChangeNotifier {
  VehicleRates? vehicleRates;
  Future<void> getVehiclesCost() async {
    DatabaseEvent vehiclesData = await fbase.child('Globals').once();
    print('Vehicles Data' + vehiclesData.snapshot.value.toString());
    var jsonData = vehiclesData.snapshot.value;
    vehicleRates = VehicleRates.fromJson(jsonData);
    notifyListeners();
    print('Vehicle Rates' + vehicleRates.toString());
  }
}
