class RideRequest {
  final carDetails;
  final destination;
  final destinationAddress;
  final driverId;
  final driverLocation;
  final driverName;
  final driverPhone;
  final fareAmount;
  final acceptedTime;
  final origin;
  final originAddress;
  final status;
  final time;
  final userName;
  final userPhone;

  RideRequest({
    this.acceptedTime,
    this.carDetails,
    this.destination,
    this.destinationAddress,
    this.driverId,
    this.driverLocation,
    this.driverName,
    this.driverPhone,
    this.fareAmount,
    this.origin,
    this.originAddress,
    this.status,
    this.time,
    this.userName,
    this.userPhone,
  });

  // Factory method to create an instance from a map (typically from Firebase)
  factory RideRequest.fromMap(var data) {
    return RideRequest(
      acceptedTime: data['acceptedTime'],
      carDetails: data['car_details'],
      destination: data['destination'],
      destinationAddress: data['destinationAddress'],
      driverId: data['driverId'],
      driverLocation: data['driverLocation'],
      driverName: data['driverName'],
      driverPhone: data['driverPhone'],
      fareAmount: data['fareAmount'],
      origin: data['origin'],
      originAddress: data['originAddress'],
      status: data['status'],
      time: data['time'],
      userName: data['userName'],
      userPhone: data['userPhone'],
    );
  }
}
