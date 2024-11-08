import 'dart:ffi';

class DeliveryVehicle {
  final String type;
  final double baseDistance;
  final double perKm;
  final double basePrice;
  final String image;
  final double? loading_capacity;
  final double? unloading_time;
  final double? waiting_charge;

  DeliveryVehicle({
    required this.type,
    required this.baseDistance,
    required this.perKm,
    required this.basePrice,
    required this.image,
    this.loading_capacity,
    this.unloading_time,
    this.waiting_charge,
  });

  factory DeliveryVehicle.fromJson(Map<String, dynamic> json) {
    return DeliveryVehicle(
      type: json['type'],
      baseDistance: json['base_distance'].toDouble(),
      perKm: json['per_km'].toDouble(),
      basePrice: json['base_price'].toDouble(),
      image: json['image'],
      loading_capacity: json['loading_capacity'] == null
          ? 0.0
          : double.parse(json['loading_capacity'].toString()),
      unloading_time: json['unloading_time'] == null
          ? 0.0
          : double.parse(json['unloading_time'].toString()) ?? 0.0,
      waiting_charge: json['waiting_charge'] == null
          ? 0.0
          : double.parse(json['waiting_charge'].toString()) ?? 0.0,
    );
  }
}
