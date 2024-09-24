import 'package:flutter/material.dart';
import 'package:users_app_cracon/Controller/assistants/request_assistant.dart';
import 'package:users_app_cracon/Controller/global/map_key.dart';
import 'package:users_app_cracon/models/predicted_places.dart';
import 'package:users_app_cracon/Views/widgets/place_prediction_tile.dart';

class SearchPlacesScreen extends StatefulWidget {
  @override
  _SearchPlacesScreenState createState() => _SearchPlacesScreenState();
}

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {
  List<PredictedPlaces> placesPredictedList = [];

  void findPlaceAutoCompleteSearch(String inputText) async {
    if (inputText.length > 1) //2 or more than 2 input characters
    {
      String urlAutoCompleteSearch =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$mapKey&components=country:IN";

      var responseAutoCompleteSearch =
          await RequestAssistant.receiveRequest(urlAutoCompleteSearch);

      if (responseAutoCompleteSearch ==
          "Error Occurred, Failed. No Response.") {
        return;
      }

      if (responseAutoCompleteSearch["status"] == "OK") {
        var placePredictions = responseAutoCompleteSearch["predictions"];

        var placePredictionsList = (placePredictions as List)
            .map((jsonData) => PredictedPlaces.fromJson(jsonData))
            .toList();

        setState(() {
          placesPredictedList = placePredictionsList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          //search place ui
          Container(
            height: 160,
            decoration: const BoxDecoration(
              color: Color(0xFFFF914D),
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 1,
                  spreadRadius: 0.5,
                  offset: Offset(
                    0.7,
                    0.7,
                  ),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const SizedBox(height: 25.0),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      const Center(
                        child: Text(
                          "Drop Location",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      const SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: _height * 0.055,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 2),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(35),
                            ),
                            child: TextField(
                              onChanged: (valueTyped) {
                                findPlaceAutoCompleteSearch(valueTyped);
                              },
                              decoration: const InputDecoration(
                                hintText: 'Drop Location',
                                border: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.location_on,
                                  color: Color(0xFFFF914D),
                                  size: 25,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          //display place predictions result
          (placesPredictedList.length > 0)
              ? Expanded(
                  child: ListView.separated(
                    itemCount: placesPredictedList.length,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return PlacePredictionTileDesign(
                        predictedPlaces: placesPredictedList[index],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        height: 1,
                        color: Colors.black,
                        thickness: 1,
                        indent: _width * 0.05,
                        endIndent: _width * 0.05,
                      );
                    },
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
