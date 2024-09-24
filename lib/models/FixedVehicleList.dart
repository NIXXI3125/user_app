class FixedVehicleType {
  final String type;
  final double Price;
  final String image;

  FixedVehicleType({
    required this.type,
    required this.Price,
    required this.image,
  });

  factory FixedVehicleType.fromJson(var json) {
    return FixedVehicleType(
      type: json['type'],
      Price: json['price'].toDouble(),
      image: json['image'],
    );
  }
}
