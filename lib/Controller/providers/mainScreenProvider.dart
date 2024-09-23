import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:users_app_cracon/Controller/assistants/request_assistant.dart';
import 'package:users_app_cracon/Controller/global/global.dart';
import 'package:users_app_cracon/Controller/global/map_key.dart';

import '../../models/predicted_placestu.dart';

enum MainScreenState {
  initial,
  loading,
  loaded,
  error,
}

class Mainscreenprovider extends ChangeNotifier {
  MainScreenState state = MainScreenState.initial;
  Position? pickupLocation;
  LocationPermission? _locationPermission;
  List<Placemark>? list;
  List<PredictedPlacestu> apiresponseList = [];
  List<PredictedPlacestu> pickupLocationList = [];
  List<PredictedPlacestu> dropLocationList = [];
  Future<void> getPickupLocation() async {
    state = MainScreenState.loading;

    pickupLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    print(pickupLocation.toString());
    userPickupLocation = pickupLocation;
    list = await placemarkFromCoordinates(
        pickupLocation!.latitude, pickupLocation!.longitude);
    print('locationData' + list.toString());
    notifyListeners();
    state = MainScreenState.loaded;
  }

  Future<void> getDropLocation(String search) async {
    state = MainScreenState.loading;
    print('locationData' + list.toString());
    await getLocationsFromString(search);
    if (apiresponseList.isEmpty || apiresponseList == []) {
      return;
    }
    if (apiresponseList.isNotEmpty || apiresponseList != []) {
      dropLocationList = apiresponseList;
      notifyListeners();
    }
    notifyListeners();
    state = MainScreenState.loaded;
  }

  Future<void> getLocationsFromString(String inputText) async {
    state = MainScreenState.initial;
    if (inputText.length > 3) {
      state = MainScreenState.loading;
      String urlAutoCompleteSrch =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$mapKey&components=country:IN";

      var responseAutoCompleteSrch =
          await RequestAssistant.receiveRequest(urlAutoCompleteSrch);

      if (responseAutoCompleteSrch == "Error Occurred, Failed. No Response.") {
        state = MainScreenState.error;
      }

      if (responseAutoCompleteSrch["status"] == "OK") {
        var placePrediction = responseAutoCompleteSrch["predictions"];

        var placePredictionList = (placePrediction as List)
            .map((jsonData) => PredictedPlacestu.fromJson(jsonData))
            .toList();
        apiresponseList = placePredictionList;
        notifyListeners();
        state = MainScreenState.loaded;
      }
    }
  }
}
