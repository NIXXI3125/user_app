class Orderhistorymodel {
  final DateTime DateofOrder;
  final String destination;
  final String origin;
  final String vehicleType;
  final String cost;

  const Orderhistorymodel({
    required this.origin,
    required this.DateofOrder,
    required this.cost,
    required this.destination,
    required this.vehicleType,
  });
}
