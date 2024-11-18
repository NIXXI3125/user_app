import 'package:users_app_cracon/Controller/global/global.dart';
import 'package:users_app_cracon/models/directions.dart';

Future saveAddress (Directions address) async {
  print("user id: $userID");
  fbase.child("users").child(userID).child("Saved Address").child(address.locationId.toString()).set(
    address.toJson(),
  ).then((value) {
    return true;
  });
  return false;
}