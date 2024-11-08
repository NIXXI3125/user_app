import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:users_app_cracon/Controller/global/global.dart';
import 'package:users_app_cracon/models/tripsHistoryModel.dart';

enum rideHistoryState {
  initial,
  loading,
  loaded,
  error,
}

class Ridehistoryprovider extends ChangeNotifier{
  rideHistoryState state = rideHistoryState.initial;
  List<String> idList = [];
  List<TripsHistoryModel> rides = [];
  listRides() async {
    state = rideHistoryState.loading;
    notifyListeners();
    try {
      FirebaseDatabase.instance.ref().child('users/$userID/rides').once().then((DatabaseEvent snapshot) {
        if (snapshot.snapshot.value != null) {
          print(snapshot.snapshot.value);
          final data = snapshot.snapshot.value as Map<dynamic, dynamic>;
          if (data != null) {
            data.forEach((key, value) {
              idList.add(key.toString());
            });
          }
          idList.forEach((element) {
            FirebaseDatabase.instance.ref().child('All Ride Requests/$element').once().then((DatabaseEvent snapshot) {
              if (snapshot.snapshot.value != null) {
              final data = snapshot.snapshot.value as Map<dynamic, dynamic>;
              if (data != null) {
                rides.add(TripsHistoryModel.fromJson(data));
              }}
            });
          }); 
        }
      });
      state = rideHistoryState.loaded;
    } catch (e) {
      state = rideHistoryState.error;
    }
    notifyListeners();
  }

  void listClear() {
    rides.clear();
    idList.clear();
  }
}