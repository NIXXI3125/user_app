import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:users_app_cracon/Controller/assistants/request_assistant.dart';
import 'package:users_app_cracon/Controller/global/map_key.dart';
import 'package:users_app_cracon/Controller/helpers/saveAddress.dart';
import 'package:users_app_cracon/Controller/infoHandler/app_info.dart';
import 'package:users_app_cracon/Views/widgets/BottomModalSheet.dart';
import 'package:users_app_cracon/models/directions.dart';
import 'package:users_app_cracon/models/predicted_places.dart';
import 'package:users_app_cracon/Views/widgets/progress_dialog.dart';

class PlacePredictionTileDesign extends StatelessWidget {
  final PredictedPlaces? predictedPlaces;

  PlacePredictionTileDesign({this.predictedPlaces});

  getPlaceDirectionDetails(String? placeId, context) async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: AddressBottomModalSheet(
              bottomModalSheetfor: 'drop',
            ),
          );
        }).then((value) async {
      showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
          message: "Setting Up Drop-Off, Please Wait",
        ),
      );
      String placeDirectionDetailsUrl =
          "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";

      var responseApi =
          await RequestAssistant.receiveRequest(placeDirectionDetailsUrl);

      Navigator.pop(context);

      if (responseApi == "Error Occurred, Failed. No Response.") {
        return;
      }
      if (responseApi["status"] == "OK") {
        Directions directions = Directions();
        directions.locationName = responseApi["result"]["name"];
        directions.locationId = placeId;
        directions.locationLatitude =
            responseApi["result"]["geometry"]["location"]["lat"];
        directions.locationLongitude =
            responseApi["result"]["geometry"]["location"]["lng"];

        Provider.of<AppInfo>(context, listen: false)
            .updateDropOffLocationAddress(directions);
        Navigator.pop(context, "obtainedDropOff");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        getPlaceDirectionDetails(predictedPlaces!.place_id, context);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              const Icon(
                Icons.add_location_alt_outlined,
                color: Color(0xFFFF914D),
              ),
              const SizedBox(
                width: 14.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      predictedPlaces!.main_text!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 2.0,
                    ),
                    Text(
                      predictedPlaces!.secondary_text!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.bookmark_border,
                  color: Color(0xFFFF914D),
                ),
                onPressed: () async {
                  String placeDirectionDetail =
                      "https://maps.googleapis.com/maps/api/place/details/json?place_id=${predictedPlaces!.place_id}&key=$mapKey";

                  var responseApi = await RequestAssistant.receiveRequest(
                      placeDirectionDetail);
                  if (responseApi == "Error Occurred, Failed. No Response.") {
                    return;
                  }

                  if (responseApi["status"] == "OK") {
                    Directions direction = Directions();
                    direction.locationName = responseApi["result"]["name"];
                    direction.locationId = predictedPlaces!.place_id;
                    direction.locationLatitude =
                        responseApi["result"]["geometry"]["location"]["lat"];
                    direction.locationLongitude =
                        responseApi["result"]["geometry"]["location"]["lng"];

                    await saveAddress(direction).then((value) {
                      if (value == true) {
                        Fluttertoast.showToast(
                            msg: "Address Saved Successfully");
                      } else {
                        Fluttertoast.showToast(
                            msg: "Address Not Saved Successfully");
                      }
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
