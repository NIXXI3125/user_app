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
  factory DriverDetails.fromJson(var json) {
    if (json['car_details'] != null) {
      return DriverDetails(
        vehicleDetails: VehicleDetails.fromJson(json['car_details']),
        name: json['name'] ?? '',
        id: json['id'] ?? '',
      );
    } else {
      return DriverDetails(
        vehicleDetails:
            VehicleDetails(carColor: '', carModel: '', carNumber: '', type: ''),
        name: json['name'] ?? '',
        id: json['id'] ?? '',
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
