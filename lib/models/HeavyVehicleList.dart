class HeavyVehicleType {
  final String type;
  final double hourlyPrice;
  final double basePrice;
  final String image;
  final double? loading_capacity;
  final double? unloading_time;
  final double? waiting_charge;

  HeavyVehicleType({
    required this.type,
    required this.hourlyPrice,
    required this.basePrice,
    required this.image,
    this.loading_capacity,
    this.unloading_time,
    this.waiting_charge,
  });

  factory HeavyVehicleType.fromJson(var json) {
    return HeavyVehicleType(
      type: json['type'],
      hourlyPrice: json['hourly_price'].toDouble(),
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
