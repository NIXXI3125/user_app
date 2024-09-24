import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app_cracon/Controller/providers/vehiclesListProvider.dart';

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
    Provider.of<Vehicleslistprovider>(context, listen: false).getVehiclesCost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Consumer<Vehicleslistprovider>(
      builder: (context, vehicle, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Available Vehicles'),
          ),
          body: ListView.separated(
            itemCount: vehicles.length,
            separatorBuilder: (context, index) {
              return Divider(
                height: 1,
                color: Colors.grey.shade400,
                indent: width * 0.1,
                endIndent: width * 0.1,
              );
            },
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                leading: Image.asset(
                  vehicles[index]['image'],
                  width: 50,
                  height: 50,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 30,
                    );
                  },
                ),
                title: Text(vehicles[index]['name']),
                trailing: Text('₹ ${vehicle.vehicleRates!.bikeBasePrice}'),
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => SelectNearestActiveDriverScreen(
                  //       vehicleType: vehicles[index]['type'],
                  //     ),
                  //   ),
                  // );
                },
              );
            },
          ),
        );
      },
    );
  }
}
