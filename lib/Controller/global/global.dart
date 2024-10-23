import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:users_app_cracon/models/PickupDetailsModel.dart';
import 'package:users_app_cracon/models/direction_details_info.dart';
import 'package:users_app_cracon/models/dropDetailModel.dart';
import '../../models/user_model.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance;
DatabaseReference fbase = FirebaseDatabase.instance.ref();
String customer_care = '+91 1234567890';
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
Position? userPickupLocation;
double? userPickupLocationLongitude;
double? userPickupLocationLatitude;
double? userDropLocationLongitude;
double? userDropLocationLatitude;
Pickupdetailsmodel pickupDetails = Pickupdetailsmodel();
Dropdetailsmodel dropDetails = Dropdetailsmodel();
List dList = []; // online oe active drivers Information List
DirectionDetailsInfo? tripDirectionDetailsInfo;
String? chosenDriverId = "";
String userName = "";
String userPhone = "";
String userID = FirebaseAuth.instance.currentUser!.uid;
