class VehicleRates {
  final double hydraBase;
  final double forkLiftPerHour;
  final double pickupPerKm;
  final double pickupBase;
  final double tataAcePerKm;
  final double tataAceBase;
  final double bikeBasePrice;
  final double jcbBase;
  final double hydraPerHour;
  final double tractorTrolleyBase;
  final double jcbPerHour;
  final double eecoBasePrice;
  final double threeWheelerBase;
  final double forkLiftBase;
  final double threeWheelerPerKm;
  final double bikePerKm;
  final double waterTankerBase;
  final double eecoPerKm;

  VehicleRates({
    required this.hydraBase,
    required this.forkLiftPerHour,
    required this.pickupPerKm,
    required this.pickupBase,
    required this.tataAcePerKm,
    required this.tataAceBase,
    required this.bikeBasePrice,
    required this.jcbBase,
    required this.hydraPerHour,
    required this.tractorTrolleyBase,
    required this.jcbPerHour,
    required this.eecoBasePrice,
    required this.threeWheelerBase,
    required this.forkLiftBase,
    required this.threeWheelerPerKm,
    required this.bikePerKm,
    required this.waterTankerBase,
    required this.eecoPerKm,
  });

  factory VehicleRates.fromJson(var json) {
    return VehicleRates(
      hydraBase: json['Hydra_base'].toDouble(),
      forkLiftPerHour: json['fork_lift_per_hour'].toDouble(),
      pickupPerKm: json['Pickup_per_km'].toDouble(),
      pickupBase: json['Pickup_Base'].toDouble(),
      tataAcePerKm: json['Tata_ace_per_km'].toDouble(),
      tataAceBase: json['Tata_Ace_base'].toDouble(),
      bikeBasePrice: json['Bike_Base_price'].toDouble(),
      jcbBase: json['jcb_base'].toDouble(),
      hydraPerHour: json['Hydra_per_hour'].toDouble(),
      tractorTrolleyBase: json['Tractor_Trolley_base'].toDouble(),
      jcbPerHour: json['jcb_per_hour'].toDouble(),
      eecoBasePrice: json['Eeco_base_price'].toDouble(),
      threeWheelerBase: json['3Wheeler_base'].toDouble(),
      forkLiftBase: json['fork_lift_base'].toDouble(),
      threeWheelerPerKm: json['3Wheeler_per_km'].toDouble(),
      bikePerKm: json['Bike_per_km'].toDouble(),
      waterTankerBase: json['WaterTanker_Base'].toDouble(),
      eecoPerKm: json['Eeco_per_km'].toDouble(),
    );
  }
}
