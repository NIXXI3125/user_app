import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app_cracon/Controller/providers/rideHistoryProvider.dart';
import 'package:users_app_cracon/models/orderHistoryModel.dart';
import 'package:users_app_cracon/models/tripsHistoryModel.dart';

class Ridehistory extends StatefulWidget {
  Ridehistory({super.key});

  @override
  State<Ridehistory> createState() => _RidehistoryState();
}

class _RidehistoryState extends State<Ridehistory> {
  List<TripsHistoryModel> orders = [];
  initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<Ridehistoryprovider>(context, listen: false).listClear();
      Provider.of<Ridehistoryprovider>(context, listen: false).listRides();
      orders = Provider.of<Ridehistoryprovider>(context, listen: false).rides;
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    final double _height = MediaQuery.of(context).size.height;
    final double _width = MediaQuery.of(context).size.width;
    return Consumer<Ridehistoryprovider>(
      builder: (BuildContext context, Ridehistoryprovider rideHistoryProvider,
          Widget? child) {
        return (rideHistoryProvider.state == rideHistoryState.loaded)
            ? Scaffold(
                body: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: _height * 0.2,
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      bottom: const PreferredSize(
                        child: Text(
                          'Ride History',
                          style: TextStyle(
                            fontSize: 35,
                            color: Colors.white,
                          ),
                        ),
                        preferredSize: Size(0, 100),
                      ),
                    ),
                    (rideHistoryProvider.rides.isEmpty)
                        ? const SliverFillRemaining(
                            child: Center(
                              child: Text(
                                'No Rides Yet',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          )
                        : SliverList.builder(
                            itemCount: rideHistoryProvider.rides.length,
                            itemBuilder: (context, index) => rideHistoryTile(
                                context: context,
                                DateofOrder:
                                    DateTime.parse(orders[index].time ?? ''),
                                destination:
                                    orders[index].destinationAddress ?? '',
                                origin: orders[index].originAddress ?? '',
                                cost: orders[index].fareAmount.toString(),
                                vehicleType: ''),
                          ),
                  ],
                ),
              )
            : Scaffold(
                body: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
      },
    );
  }
}

Widget rideHistoryTile({
  required BuildContext context,
  required DateTime DateofOrder,
  required String destination,
  required String origin,
  required String vehicleType,
  required String? cost,
}) {
  double _height = MediaQuery.of(context).size.height;
  double _width = MediaQuery.of(context).size.width;
  return Container(
    margin: const EdgeInsets.all(10),
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black45,
          width: 0.35,
        )),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            children: [
              Text(
                DateofOrder.toString(),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.grey.shade400,
          indent: _width * 0.03,
          endIndent: _width * 0.03,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Column(
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.green,
                  size: 30,
                ),
                SizedBox(
                  height: 20,
                ),
                Icon(
                  Icons.location_on_outlined,
                  color: Colors.red,
                  size: 30,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  destination,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  origin,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          height: _height * 0.05,
          margin: const EdgeInsets.only(
            top: 10,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
          ),
          child: Row(
            children: [
              Text(
                vehicleType,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Text(
                cost != 'null' ? '\Rs. $cost' : 'Cancelled',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
