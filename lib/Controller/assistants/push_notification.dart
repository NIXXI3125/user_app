import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;
import 'package:provider/provider.dart';
import 'package:users_app_cracon/Controller/infoHandler/app_info.dart';
import '../global/global.dart';

class PushNotification
{
  static Future<String> getAccessToken() async
  {
    final serviceAccountJson =
    {
        "type": "service_account",
        "project_id": "user555-3d756",
        "private_key_id": "21d9d277adc664d8464f02141e8466255775f0aa",
        "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCOjVCnpNP7qf/g\nzEQaXf023c37YAq8RzrUh7ugRbyXvt8gQq7e6U54N2wNyPFLUpfMweF5d7F5jnDI\nKO7A1OdgiJwidxcTt1b1V8H3M6CwzFx0sxtqDcI7DFGL36lrFeukQmlKl1IER6qL\nasJxV3rgXmG/tl38B5n4OLm6b3LCMUneBRqBMdt6R6NOxEOy532EzjaHkievK8Qq\n99br9/DDyEw5bu4MIcXUY/OeSVEOqhq2Mv7bfsXGYAMKzVtetFhKMJYGguB3fF05\nzYGn0hCoKSp/gEW4odZLWTbg0JribFwP0wTKvshtthUPR4yx6qjNp6WZfp481WFQ\nH2gQCqLjAgMBAAECggEAP/YFOes5mEJbRqSwa/o/Gsaj3QXnWzpEmca7N3sC1z1z\nxPhWmTsqk8MeTwMZzTemV9+oSQWdEpMIZK8FDW2Z0ZUKJWa06opJULULGV1HXPyd\nAVm507iPrUnmLvHwhNVlkSKhNrA1wyjay0pgK1XakuCWUFxFyEcq3Raqsw29eobS\nYjmq6WCAzuVitQb2MrmsWO3ZRFcWHpRz/YWr7mlRT/7r6tJ/O0b0j0uCRr3VSjfZ\nJGw5IqSrJdb9Y2S7waQ7aEPIzOa0AV44pAtxi+Duey61Z/irzbJ5ckXyEWOTer2Z\n7AxaIVpI462KkUNCmPnQ3iGmdNiy/63aLevHYBxikQKBgQDIfusEJNXnz5KViDrm\nq10WTmutlUj1LB1mfQ1rVJGF/lAUbcQus9wGGZrOz/LndCSSXiLGi658InRRNlh3\nBPl0ynmYQEJk/F2w7Y9sDUEa52xVzN8A0UkuPlh4wuKj2gpCFmbm8IASY9MvYLBj\nRWvmOGDJxw9QYCtNiOXbOVvHMQKBgQC2A/Anh0Dwt2ct1en7vWpvRNFHySthTw4v\n1aS52Pzg30w+1QbKJFy3ZnpFwEopwSGA6CaZDWlTSUzc8TuVm23KCMcyWhBvgEWO\nwsoWOBX4H83MO+8EzJ3umdNMqeWMLKEb0ZLAa2ThOos/tgArL0fbpLQSpslgUuQj\nSQriWlJuUwKBgE5ht9Ut5WYzsxW8ZXKKaeDvlY8N/rDCp1fK6bUdIaslqf7ijsDH\nVewYlHnnuAmeUTHblXLTZspm2dxqB5m4GyH6iiDodkxukN47cUeHwv0WnjbI2iHC\nr/5hJ0tGvT3bXwlJIr+EJD2MQyKRhUO5/x3IyqX3qVf90NAGBf53ZRbxAoGAfF9o\nhLopJ9NKz8kyH3Co/+s4TiMqX03T1d/YtZ2N/mLXCMAr6Yi7Sh7eQjdI9gsgR6Na\nbI77f4vA1+CG5I3WkY06ADAGtwohfZGg4VnluSySRZJWmyLucBHwjpwxXH1KgWXN\nL2qy/iww5pIIv3mJUo7S9UO+qvE5LttEcrNhTD0CgYEAmsKwe6DpDKUHdBDhiF4q\nwoOdG0f3t6zCd4SE7zA3BliCcPLWdDMACt6LaD42S5uUOrfYHDaFkcRq4tWGk4Ui\n2/I9gyX1jXdQ2LaEOKMfIX1HggRzVwfr7b9uTOpjaOKTsYwqxb4lAiDerMs9Zpf+\nyoFKOpUVL9KYn0hL/ZrNWTI=\n-----END PRIVATE KEY-----\n",
        "client_email": "cracon-notifications@user555-3d756.iam.gserviceaccount.com",
        "client_id": "111530895475760429719",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/cracon-notifications%40user555-3d756.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com"
    };
    List<String> scopes =
    [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes
    );

    auth.AccessCredentials credentials = await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client,
    );

    client.close();

    return credentials.accessToken.data;
  }

  static sendNotificationToSelectedDriver(String deviceRegistrationToken, String userRideRequestId, context) async
  {
     String dropOffDestinationAddress = Provider.of<AppInfo>(context, listen: false).userDropOffLocation!.locationName.toString();
     String pickUpAddress = Provider.of<AppInfo>(context, listen: false).userPickUpLocation!.locationName.toString();
    final String serverAccessTokenKey = await getAccessToken();
    String endPointFirebaseCloudMessaging = 'https://fcm.googleapis.com/v1/projects/user555-3d756/messages:send';

    final Map<String, dynamic> message =
    {
      'message':
      {
        'token': deviceRegistrationToken,
        'notification':
        {
          'title': "NET TRIP REQUEST from $userName",
          'body' : "PickUp Location: $pickUpAddress \n DropOff Location: $dropOffDestinationAddress"
        },
        'data':
        {
          'rideRequestId': userRideRequestId,
        }
      }
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(endPointFirebaseCloudMessaging),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serverAccessTokenKey'
        },
        body: jsonEncode(message),
      );
      if(response.statusCode == 200)
      {
        print("Notification Sent Successfully.");
      }
      else
      {
        print("Notification Not Sent: ${response.body}");
      }
    }
    catch(e){print("Notification Not Sent: ${e.toString()}");}

  }
}