import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app_cracon/Controller/assistants/request_assistant.dart';
import 'package:users_app_cracon/Controller/global/map_key.dart';
import 'package:users_app_cracon/Controller/infoHandler/app_info.dart';
import 'package:users_app_cracon/Views/widgets/BottomModalSheet.dart';
import 'package:users_app_cracon/models/directions.dart';
import 'package:users_app_cracon/models/predicted_placestu.dart';
import 'package:users_app_cracon/Views/widgets/progress_dialog.dart';

class PlacePredictionTileDsgn extends StatelessWidget {
  final PredictedPlacestu? predictedPlacestu;

  PlacePredictionTileDsgn({this.predictedPlacestu});

  getPlaceDirectionDetail(String? placeId, context) async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: AddressBottomModalSheet(
              bottomModalSheetfor: 'pickup',
            ),
          );
        }).then(
      (value) async {
        showDialog(
          context: context,
          builder: (BuildContext context) => ProgressDialog(
            message: "Setting Up Pick Up, Please Wait...",
          ),
        );
        String placeDirectionDetail =
            "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";

        var responseApi =
            await RequestAssistant.receiveRequest(placeDirectionDetail);

        Navigator.pop(context);

        if (responseApi == "Error Occurred, Failed. No Response.") {
          return;
        }

        if (responseApi["status"] == "OK") {
          Directions direction = Directions();
          direction.locationName = responseApi["result"]["name"];
          direction.locationId = placeId;
          direction.locationLatitude =
              responseApi["result"]["geometry"]["location"]["lat"];
          direction.locationLongitude =
              responseApi["result"]["geometry"]["location"]["lng"];

          Provider.of<AppInfo>(context, listen: false)
              .updatePickUpLocationAddress(
            direction,
          );

          Navigator.pop(context, "obtainedPickup");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          getPlaceDirectionDetail(predictedPlacestu!.place_id, context),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
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
                      predictedPlacestu!.main_text!,
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
                      predictedPlacestu!.secondary_text!,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(fontSize: 12.0, color: Colors.black),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
