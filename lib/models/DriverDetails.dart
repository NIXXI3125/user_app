import 'package:firebase_database/firebase_database.dart';
import 'package:users_app_cracon/models/VehicleDetails.dart';

class DriverDetails {
  final VehicleDetails? vehicleDetails;
  final String name;
  final String id;

  DriverDetails({
    required this.vehicleDetails,
    required this.name,
    required this.id,
  });

  // You can also include methods for serialization if needed
  factory DriverDetails.fromJson(DataSnapshot json) {
    if ((json.value as dynamic)['car_details'] != null) {
      return DriverDetails(
        vehicleDetails:
            VehicleDetails.fromJson((json.value as dynamic)['car_details']),
        name: (json.value as dynamic)['name'] ?? '',
        id: (json.value as dynamic)['id'] ?? '',
      );
    } else {
      return DriverDetails(
        vehicleDetails:
            VehicleDetails(carColor: '', carModel: '', carNumber: '', type: ''),
        name: (json.value as dynamic)['name'] ?? '',
        id: (json.value as dynamic)['id'] ?? '',
      );
    }
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'car_color': carColor,
  //     'car_model': carModel,
  //     'car_number': carNumber,
  //     'type': type,
  //   };
  // }
}
