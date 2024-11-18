import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app_cracon/Controller/global/global.dart';
import 'package:users_app_cracon/Controller/providers/searchingScreenProvider.dart';
import 'package:users_app_cracon/Controller/providers/vehiclesListProvider.dart';
import 'package:users_app_cracon/Views/mainScreens/Tripsummaryscreen.dart';
import 'package:users_app_cracon/Views/mainScreens/searching_screens.dart';

class VehiclesList extends StatefulWidget {
  VehiclesList({super.key, this.referenceRideRequest});
  DatabaseReference? referenceRideRequest;
  @override
  State<VehiclesList> createState() => _VehiclesListState();
}

class _VehiclesListState extends State<VehiclesList> {
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      final provider =
          Provider.of<Vehicleslistprovider>(context, listen: false);
      provider.getAllVehiclesCost();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Vehicleslistprovider>(
      builder: (context, vehicle, _) {
        return (vehicle.state == VehicleState.loaded)
            ? Scaffold(
                appBar: AppBar(
                  title: const Text('Available Vehicles'),
                ),
                body: ListView(
                  children: [
                    if (vehicle.deliveryvehicleList != null)
                      ...List.generate(
                        vehicle.deliveryvehicleList!.length,
                        (index) {
                          return buildVehicleTile(
                            image: vehicle.deliveryvehicleList![index].image,
                            loadingCapacity: vehicle
                                .deliveryvehicleList![index].loading_capacity
                                ?.ceil()
                                .toString(),
                            type: vehicle.deliveryvehicleList![index].type
                                .split('_')
                                .map((word) =>
                                    word[0].toUpperCase() + word.substring(1))
                                .join(' '),
                            cost:
                                '₹ ${vehicle.calculateFareAmountFromOriginToDestination(directionDetailsInfo: tripDirectionDetailsInfo!, vehicle: vehicle.deliveryvehicleList![index])}',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Tripsummaryscreen(
                                          vehicleType: vehicle
                                              .deliveryvehicleList![index].type,
                                          vehicleImage: vehicle
                                              .deliveryvehicleList![index]
                                              .image,
                                          loadingCapacity: vehicle
                                              .deliveryvehicleList![index]
                                              .loading_capacity,
                                          unloadingTime: vehicle
                                              .deliveryvehicleList![index]
                                              .unloading_time,
                                          waitingCharge: vehicle
                                              .deliveryvehicleList![index]
                                              .waiting_charge,
                                          cost:
                                              '₹ ${vehicle.calculateFareAmountFromOriginToDestination(directionDetailsInfo: tripDirectionDetailsInfo!, vehicle: vehicle.deliveryvehicleList![index])}',
                                        )),
                              );
                            },
                          );
                        },
                      ),
                    if (vehicle.fixedvehicleList != null)
                      ...List.generate(
                        vehicle.fixedvehicleList!.length,
                        (index) {
                          return buildVehicleTile(
                            image: vehicle.fixedvehicleList![index].image,
                            type: vehicle.fixedvehicleList![index].type
                                .split('_')
                                .map((word) =>
                                    word[0].toUpperCase() + word.substring(1))
                                .join(' '),
                            cost: '₹ ${vehicle.fixedvehicleList![index].price}',
                            loadingCapacity: vehicle
                                .fixedvehicleList![index].loading_capacity
                                ?.ceil()
                                .toString(),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Tripsummaryscreen(
                                          vehicleType: vehicle
                                              .fixedvehicleList![index].type,
                                          cost:
                                              '₹ ${vehicle.fixedvehicleList![index].price}',
                                          vehicleImage: vehicle
                                              .fixedvehicleList![index].image,
                                          loadingCapacity: vehicle
                                              .fixedvehicleList![index]
                                              .loading_capacity,
                                          unloadingTime: vehicle
                                              .fixedvehicleList![index]
                                              .unloading_time,
                                          waitingCharge: vehicle
                                              .fixedvehicleList![index].waiting_charge,
                                        )),
                              );
                            },
                          );
                        },
                      ),
                    if (vehicle.heavyvehicleList != null)
                      ...List.generate(
                        vehicle.heavyvehicleList!.length,
                        (index) {
                          return buildVehicleTile(
                            image: vehicle.heavyvehicleList![index].image,
                            type: vehicle.heavyvehicleList![index].type
                                .split('_')
                                .map((word) =>
                                    word[0].toUpperCase() + word.substring(1))
                                .join(' '),
                            loadingCapacity: vehicle.heavyvehicleList![index]
                                .loading_capacity
                                ?.ceil()
                                .toString(),
                            cost:
                                '₹ ${vehicle.heavyvehicleList![index].basePrice}',
                            isHeavy: true,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Tripsummaryscreen(
                                          vehicleType: vehicle
                                              .heavyvehicleList![index].type,
                                          cost:
                                              '₹ ${vehicle.heavyvehicleList![index].basePrice}',
                                          vehicleImage: vehicle
                                              .heavyvehicleList![index].image,
                                          loadingCapacity: vehicle
                                              .heavyvehicleList![index]
                                              .loading_capacity,
                                          unloadingTime: vehicle
                                              .heavyvehicleList![index]
                                              .unloading_time,
                                          waitingCharge: vehicle
                                              .heavyvehicleList![index].waiting_charge,
                                        )),
                              );
                            },
                          );
                        },
                      ),
                  ],
                ),
              )
            : const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
      },
    );
  }
}

Widget buildVehicleTile({
  required String image,
  required String type,
  required String cost,
  String? loadingCapacity,
  required VoidCallback onTap,
  bool isHeavy = false,
}) {
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
    leading: Image.network(
      image,
      width: 50,
      height: 50,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(
          Icons.error,
          color: Colors.red,
          size: 30,
        );
      },
    ),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          type,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        (loadingCapacity != null)
            ? Text(
                "$loadingCapacity Kgs",
                style: const TextStyle(fontSize: 12),
              )
            : const SizedBox.shrink(),
      ],
    ),
    trailing: isHeavy
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(cost, style: const TextStyle(fontSize: 14)),
              const Text("/hr", style: TextStyle(fontSize: 12)),
            ],
          )
        : Text(cost, style: const TextStyle(fontSize: 14)),
    onTap: onTap,
  );
}
