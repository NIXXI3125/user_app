import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app_cracon/Controller/providers/searchingScreenProvider.dart';

class SearchingScreens extends StatefulWidget {
  const SearchingScreens({super.key});

  @override
  State<SearchingScreens> createState() => _SearchingScreensState();
}

class _SearchingScreensState extends State<SearchingScreens> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<Searchingscreenprovider>(context, listen: false)
          .currentonlinedrivers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<Searchingscreenprovider>(
          builder: (context, screenprovider, _) {
        return Container(
          child: Column(
            children: [
              LinearProgressIndicator(),
              Text('Searching For Doctors .....')
            ],
          ),
        );
      }),
    );
  }
}
