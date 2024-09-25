import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app_cracon/Controller/global/global.dart';
import 'package:users_app_cracon/Controller/providers/searchingScreenProvider.dart';
import 'package:users_app_cracon/Controller/providers/vehiclesListProvider.dart';
import 'package:users_app_cracon/Views/mainScreens/searching_screens.dart';

class VehiclesList extends StatefulWidget {
  VehiclesList({super.key, this.referenceRideRequest});
  DatabaseReference? referenceRideRequest;
  @override
  State<VehiclesList> createState() => _VehiclesListState();
}

class _VehiclesListState extends State<VehiclesList> {
  List<Map> vehicles = [
    {
      'name': 'Bike',
      'type': 'bike',
      'image': 'android/images/Bike.png',
    },
    {
      'name': '3-wheeler',
      'type': '3wheel',
      'image': 'android/images/3_wheeler.png',
    },
    {
      'name': 'Tata-Ace',
      'type': 'tataace',
      'image': 'android/images/Tata-Ace.png',
    },
    {
      'name': 'Eeco',
      'type': 'eeco',
      'image': 'android/images/eeco.png',
    },
    {
      'name': 'Pickup',
      'type': 'pickup',
      'image': 'android/images/pickup.png',
    },
    {
      'name': 'Hydra',
      'type': 'hydra',
      'image': 'android/images/Hydra.png',
    },
    {
      'name': 'Fork-Lift',
      'type': 'forklift',
      'image': 'android/images/Fork-Lift.png',
    },
    {
      'name': 'Excavator',
      'type': 'Excavator',
      'image': 'android/images/Excavator.png',
    },
    {
      'name': 'Water-Tanker',
      'type': 'waterTanker',
      'image': 'android/images/Water-Tanker.png',
    },
    {
      'name': 'Tractor Trolley',
      'type': 'tractorTrolley',
      'image': 'android/images/Tractor-Trolley.png',
    },
  ];

  @override
  void initState() {
    Provider.of<Vehicleslistprovider>(context, listen: false)
        .getHeavyVehiclesCost();
    Provider.of<Vehicleslistprovider>(context, listen: false)
        .getDeliveryVehiclesCost();
    Provider.of<Vehicleslistprovider>(context, listen: false)
        .getFixedVehiclesCost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Consumer<Vehicleslistprovider>(
      builder: (context, vehicle, _) {
        return (vehicle.state == VehicleState.initial ||
                vehicle.state == VehicleState.loading)
            ? const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  title: const Text('Available Vehicles'),
                ),
                body: (vehicle.deliveryvehicleList == null)
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            ...List.generate(
                              vehicle.deliveryvehicleList!.length,
                              (index) {
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 5),
                                  leading: Image.network(
                                    vehicle.deliveryvehicleList![index].image,
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
                                  title: Text(
                                      vehicle.deliveryvehicleList![index].type),
                                  trailing: Text(
                                    "₹ ${vehicle.calculateFareAmountFromOriginToDestination(directionDetailsInfo: tripDirectionDetailsInfo!, vehicle: vehicle.deliveryvehicleList![index])}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChangeNotifierProvider(
                                                create: (context) =>
                                                    Searchingscreenprovider(),
                                                child: SearchingScreens(
                                                  VehicleType: vehicle
                                                      .deliveryvehicleList![
                                                          index]
                                                      .type,
                                                  cost:
                                                      '₹ ${vehicle.calculateFareAmountFromOriginToDestination(directionDetailsInfo: tripDirectionDetailsInfo!, vehicle: vehicle.deliveryvehicleList![index])}',
                                                ),
                                              )),
                                    );
                                  },
                                );
                              },
                            ),
                            ...List.generate(
                              vehicle.fixedvehicleList!.length,
                              (index) {
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 5),
                                  leading: Image.network(
                                    vehicle.fixedvehicleList![index].image,
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
                                  title: Text(
                                      vehicle.fixedvehicleList![index].type),
                                  trailing: Text(
                                    "₹ ${vehicle.calculateFareAmountForFixedVehicles(directionDetailsInfo: tripDirectionDetailsInfo!, vehicle: vehicle.fixedvehicleList![index])}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChangeNotifierProvider(
                                                create: (context) =>
                                                    Searchingscreenprovider(),
                                                child: SearchingScreens(
                                                  VehicleType: vehicle
                                                      .deliveryvehicleList![
                                                          index]
                                                      .type,
                                                  cost:
                                                      '₹ ${vehicle.calculateFareAmountFromOriginToDestination(directionDetailsInfo: tripDirectionDetailsInfo!, vehicle: vehicle.deliveryvehicleList![index])}',
                                                ),
                                              )),
                                    );
                                  },
                                );
                              },
                            ),
                            ...List.generate(
                              vehicle.heavyvehicleList!.length,
                              (index) {
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 5),
                                  leading: Image.network(
                                    vehicle.heavyvehicleList![index].image,
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
                                  title: Text(
                                      vehicle.heavyvehicleList![index].type),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "₹ ${vehicle.calculateFareAmountForHeavyVehicles(directionDetailsInfo: tripDirectionDetailsInfo!, vehicle: vehicle.heavyvehicleList![index])}",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const Text(
                                        "/hr",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChangeNotifierProvider(
                                                create: (context) =>
                                                    Searchingscreenprovider(),
                                                child: SearchingScreens(
                                                  VehicleType: vehicle
                                                      .deliveryvehicleList![
                                                          index]
                                                      .type,
                                                  cost:
                                                      '₹ ${vehicle.calculateFareAmountFromOriginToDestination(directionDetailsInfo: tripDirectionDetailsInfo!, vehicle: vehicle.deliveryvehicleList![index])}',
                                                ),
                                              )),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
              );
      },
    );
  }
}
