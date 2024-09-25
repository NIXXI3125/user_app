import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app_cracon/Controller/providers/searchingScreenProvider.dart';

class SearchingScreens extends StatefulWidget {
  const SearchingScreens({super.key, this.cost, this.VehicleType});
  final String? VehicleType;
  final String? cost;
  @override
  State<SearchingScreens> createState() => _SearchingScreensState();
}

class _SearchingScreensState extends State<SearchingScreens> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<Searchingscreenprovider>(context, listen: false)
          .currentonlinedrivers(context, '₹ ${widget.cost}');
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Provider.of<Searchingscreenprovider>(context, listen: false)
        .rideRequestStreamController
        .close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<Searchingscreenprovider>(
          builder: (context, screenprovider, _) {
        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LinearProgressIndicator(),
            Text(
              'Searching For Drivers .....',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        );
      }),
    );
  }
}
