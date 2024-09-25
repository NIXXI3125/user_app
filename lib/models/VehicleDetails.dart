class VehicleDetails {
  final String carColor;
  final String carModel;
  final String carNumber;
  final String type;

  VehicleDetails({
    required this.carColor,
    required this.carModel,
    required this.carNumber,
    required this.type,
  });

  // You can also include methods for serialization if needed
  factory VehicleDetails.fromJson(var json) {
    return VehicleDetails(
      carColor: json['car_color'] ?? '',
      carModel: json['car_model'] ?? '',
      carNumber: json['car_number'] ?? '',
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'car_color': carColor,
      'car_model': carModel,
      'car_number': carNumber,
      'type': type,
    };
  }
}
