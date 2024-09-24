class HeavyVehicleType {
  final String type;
  final double hourlyPrice;
  final double basePrice;
  final String image;

  HeavyVehicleType({
    required this.type,
    required this.hourlyPrice,
    required this.basePrice,
    required this.image,
  });

  factory HeavyVehicleType.fromJson(var json) {
    return HeavyVehicleType(
      type: json['type'],
      hourlyPrice: json['hourly_price'].toDouble(),
      basePrice: json['base_price'].toDouble(),
      image: json['image'],
    );
  }
}
