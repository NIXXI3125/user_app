import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app_cracon/Controller/providers/searchingScreenProvider.dart';
import 'package:users_app_cracon/Views/mainScreens/searching_screens.dart';
import 'package:users_app_cracon/constants.dart';

class Tripsummaryscreen extends StatelessWidget {
  const Tripsummaryscreen(
      {super.key,
      required this.cost,
      required this.vehicleType,
      this.loadingCapacity,
      this.unloadingTime,
      this.waitingCharge,
      required this.vehicleImage});
  final String cost;
  final String vehicleType;
  final String vehicleImage;
  final double? loadingCapacity;
  final double? unloadingTime;
  final double? waitingCharge;

  @override
  Widget build(BuildContext context) {
    Color shadowColor = Colors.grey.shade300;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Booking'),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) => ChangeNotifierProvider(
                create: (context) => Searchingscreenprovider(),
                child: SearchingScreens(
                  VehicleType: vehicleType,
                  cost: cost,
                ),
              ),
            ));
          },
          child: const Text('Book Now', style: TextStyle(fontSize: 18)),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 2,
                    offset: const Offset(0, 2),
                    blurStyle: BlurStyle.normal,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                        vehicleImage,
                        height: 80,
                        width: 80,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vehicleType.split('_')
                                .map((word) =>
                                    word[0].toUpperCase() + word.substring(1))
                                .join(' '),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  (loadingCapacity != null) ?Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: const LinearGradient(
                        colors: [primary, accent],
                        stops: [0.8, 1.0],
                      ),
                    ),
                    child:  Row(
                      children: [
                        Text(
                          'Free ${unloadingTime?.ceil()} mins of loading and unloading Time.',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ) ,
                  ): SizedBox.shrink(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Fare Summary',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor,
                          blurRadius: 2,
                          offset: const Offset(0, 2),
                          blurStyle: BlurStyle.normal,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Trip Fare',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                cost,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                          child: Divider(),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Fare',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                cost,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Read Before Booking',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 5,
                    ),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor,
                          blurRadius: 2,
                          offset: const Offset(0, 2),
                          blurStyle: BlurStyle.normal,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Wrap(
                          children: [
                            bulletLines(
                                'Fare doesn\'t include labour \ncharges for loading & unloading'),
                            bulletLines(
                                'Fare includes ${unloadingTime?.ceil()} mins free\nloading/unloading time.'),
                            bulletLines(
                                '₹ ${waitingCharge?.ceil()}/min for additional loading/\nunloading time.'),
                            bulletLines(
                                'Fare may change if route \nor location changes.'),
                            bulletLines(
                                'Parking charges to be paid by \ncustomer.'),
                            bulletLines(
                                'Fare includes toll and permit \ncharges, if any.'),
                            bulletLines('We don\'t allow overloading.'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget bulletLines(String text) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        '•   ',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: Colors.black.withOpacity(0.5),
        ),
      ),
    ],
  );
}
