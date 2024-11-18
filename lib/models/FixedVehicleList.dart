class FixedVehicleType {
  final String type;
  final double price;
  final String image;
  final double? loading_capacity;
  final double? unloading_time;
  final double? waiting_charge;

  FixedVehicleType({
    required this.type,
    required this.price,
    required this.image,
    this.loading_capacity,
    this.unloading_time,
    this.waiting_charge,
  });

  factory FixedVehicleType.fromJson(var json) {
    return FixedVehicleType(
      type: json['type'],
      price: json['price'].toDouble(),
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
