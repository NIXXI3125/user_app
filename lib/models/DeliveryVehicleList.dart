class DeliveryVehicle {
  final String type;
  final double baseDistance;
  final double perKm;
  final double basePrice;
  final String image;

  DeliveryVehicle({
    required this.type,
    required this.baseDistance,
    required this.perKm,
    required this.basePrice,
    required this.image,
  });

  factory DeliveryVehicle.fromJson(Map<String, dynamic> json) {
    return DeliveryVehicle(
      type: json['type'],
      baseDistance: json['base_distance'].toDouble(),
      perKm: json['per_km'].toDouble(),
      basePrice: json['base_price'].toDouble(),
      image: json['image'],
    );
  }
}
