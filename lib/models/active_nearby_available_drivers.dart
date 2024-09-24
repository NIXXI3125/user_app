class ActiveNearbyAvailableDrivers {
  String? driverId;
  double? locationLatitude;
  double? locationLongitude;

  ActiveNearbyAvailableDrivers({
    this.driverId,
    this.locationLatitude,
    this.locationLongitude,
  });

  factory ActiveNearbyAvailableDrivers.fromJson(
      String id, Map<String, dynamic> json) {
    return ActiveNearbyAvailableDrivers(
        driverId: id,
        locationLatitude: json['l'][0],
        locationLongitude: json['l'][1]);
  }
}
