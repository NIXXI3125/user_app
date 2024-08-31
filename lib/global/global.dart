import 'package:firebase_auth/firebase_auth.dart';
import 'package:users_app_cracon/models/direction_details_info.dart';
import '../models/user_model.dart';



final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
List dList = []; // online oe active drivers Information List
DirectionDetailsInfo? tripDirectionDetailsInfo;
String? chosenDriverId="";
String userName = "";
String userPhone = "";
String userID = FirebaseAuth.instance.currentUser!.uid;