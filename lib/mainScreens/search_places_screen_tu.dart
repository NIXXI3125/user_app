
import 'package:flutter/material.dart';
import 'package:users_app_cracon/assistants/request_assistant.dart';
import 'package:users_app_cracon/global/map_key.dart';
import 'package:users_app_cracon/models/predicted_placestu.dart';
import 'package:users_app_cracon/widgets/place_prediction_tiletu.dart';

class SearchPlacesScreenTu extends StatefulWidget
{
  @override
  State<SearchPlacesScreenTu> createState() => _SearchPlacesScreenTuState();
}




class _SearchPlacesScreenTuState extends State<SearchPlacesScreenTu>
{
  List<PredictedPlacestu> placePredictedtuList = [];

  void findPlaceAutoCompleteSrch(String inputText) async
  {
    if(inputText.length > 1)
    {
      String urlAutoCompleteSrch = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$mapKey&components=country:IN";

      var responseAutoCompleteSrch = await RequestAssistant.receiveRequest(urlAutoCompleteSrch);

      if(responseAutoCompleteSrch == "Error Occurred, Failed. No Response.")
      {
        return;
      }

      if(responseAutoCompleteSrch["status"] == "OK")
      {
        var placePrediction = responseAutoCompleteSrch["predictions"];

        var placePredictionList = (placePrediction as List).map((jsonData) => PredictedPlacestu.fromJson(jsonData)).toList();

        setState(() {
          placePredictedtuList = placePredictionList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // SEARCH PLACE UI
          Container(
            height: 160,
            decoration: const BoxDecoration(
              color: Colors.black54,
              boxShadow:
              [
                BoxShadow(
                  color: Colors.lightGreen,
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
                        onTap: ()
                        {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),

                      const Center(
                        child: Text(
                          "Set Pick Up Location",
                          style: TextStyle(
                            fontSize: 20,
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

                      const Icon(
                        Icons.adjust_sharp,
                        color: Colors.white,
                      ),


                      const SizedBox(width: 18.0,),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (valueTyped)
                            {
                              findPlaceAutoCompleteSrch(valueTyped);
                            },
                            decoration: const InputDecoration(
                              hintText: "Search Here...",
                              fillColor: Colors.white,
                              filled: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                left: 11.0,
                                top: 8.0,
                                bottom: 8.0,
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

          // DISPLAY PLACE PREDICTION RESULTS
          (placePredictedtuList.length > 0)
              ? Expanded(
                  child: ListView.separated(
                    itemCount: placePredictedtuList.length,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index)
                    {
                      return PlacePredictionTileDsgn(
                        predictedPlacestu: placePredictedtuList[index],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index)
                    {
                      return const Divider(
                        height: 1,
                        color: Colors.white70,
                        thickness: 1,
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
