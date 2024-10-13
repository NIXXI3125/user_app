import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/apigeeregistry/v1.dart';
import 'package:users_app_cracon/models/orderHistoryModel.dart';

class Ridehistory extends StatelessWidget {
  Ridehistory({super.key});
  List<Orderhistorymodel> orders = [
    Orderhistorymodel(
        origin: 'Faridabad',
        DateofOrder: DateTime(2002),
        cost: '100',
        destination: 'Ballabgarh',
        vehicleType: 'Tata-Ace')
  ];

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
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
          SliverList.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) => rideHistoryTile(
              context: context,
              DateofOrder: orders[index].DateofOrder,
              destination: orders[index].destination,
              origin: orders[index].origin,
              vehicleType: orders[index].vehicleType,
              cost: orders[index].cost,
            ),
          ),
        ],
      ),
    );
  }
}

Widget rideHistoryTile({
  required BuildContext context,
  required DateTime DateofOrder,
  required String destination,
  required String origin,
  required String vehicleType,
  required String cost,
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
                cost,
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
