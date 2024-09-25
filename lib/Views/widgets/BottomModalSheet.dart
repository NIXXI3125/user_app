import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:users_app_cracon/Controller/global/global.dart';
import 'package:users_app_cracon/Controller/infoHandler/app_info.dart';
import 'package:users_app_cracon/models/PickupDetailsModel.dart';
import 'package:users_app_cracon/models/dropDetailModel.dart';

class AddressBottomModalSheet extends StatefulWidget {
  const AddressBottomModalSheet({super.key, required this.bottomModalSheetfor});
  final String bottomModalSheetfor;
  @override
  State<AddressBottomModalSheet> createState() =>
      _AddressBottomModalSheetState();
}

class _AddressBottomModalSheetState extends State<AddressBottomModalSheet> {
  final GlobalKey<ScaffoldState> _modelScaffoldKey = GlobalKey<ScaffoldState>();
  bool _visible = false;
  TextEditingController pickupAddress = TextEditingController();
  TextEditingController pickupName = TextEditingController();
  TextEditingController pickupphone = TextEditingController();
  TextEditingController dropAddress = TextEditingController();
  TextEditingController dropName = TextEditingController();
  TextEditingController dropphone = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final double _height = MediaQuery.of(context).size.height;
    final double _width = MediaQuery.of(context).size.width;
    return Container(
      height: _height,
      decoration: const BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Visibility(
                visible: _visible,
                child: Container(
                  margin: EdgeInsets.fromLTRB(5, 5, 5, 10),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_sharp, color: Colors.white, size: 30),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Please Complete all Details',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              (widget.bottomModalSheetfor == 'pickup')
                  ?
                  // Pickup Container
                  Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(15),
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black54,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(25)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextFormField(
                                controller: pickupAddress,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    gapPadding: 5,
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 0.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    gapPadding: 5,
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      gapPadding: 5,
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 0.5)),
                                  hintText: 'Floor or Plot Number',
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: pickupName,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    gapPadding: 5,
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 0.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    gapPadding: 5,
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      gapPadding: 5,
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 0.5)),
                                  hintText: 'Contact Name',
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: pickupphone,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10)
                                ],
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    gapPadding: 5,
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 0.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    gapPadding: 5,
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      gapPadding: 5,
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 0.5)),
                                  hintText: 'Contact Number',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 20,
                          top: -4,
                          child: Container(
                            padding: const EdgeInsets.only(
                                bottom: 10, left: 10, right: 10),
                            color: Colors.white,
                            child: const Text(
                              'Enter Pickup Details',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ) // Drop Container
                  : Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(15),
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black54,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(25)),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: dropAddress,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    gapPadding: 5,
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 0.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    gapPadding: 5,
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      gapPadding: 5,
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 0.5)),
                                  hintText: 'Enter Full Address',
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: dropName,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    gapPadding: 5,
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 0.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    gapPadding: 5,
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      gapPadding: 5,
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 0.5)),
                                  hintText: 'Enter Contact Name',
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: dropphone,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10)
                                ],
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    gapPadding: 5,
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 0.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    gapPadding: 5,
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      gapPadding: 5,
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 0.5)),
                                  hintText: 'Enter Contact Number',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 20,
                          top: -4,
                          child: Container(
                            padding: const EdgeInsets.only(
                                bottom: 10, left: 10, right: 10),
                            color: Colors.white,
                            child: const Text(
                              'Enter Drop Details',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
              SizedBox(
                height: 10,
              ),
              // Button
              GestureDetector(
                onTap: () {
                  if (widget.bottomModalSheetfor == 'pickup') {
                    if (pickupphone.text.isNotEmpty ||
                        pickupName.text.isNotEmpty ||
                        pickupAddress.text.isNotEmpty) {
                      Provider.of<AppInfo>(context, listen: false)
                          .userPickUpDetails(
                        Pickupdetailsmodel(
                            address: pickupAddress.text,
                            name: pickupName.text,
                            phoneNo: pickupphone.text),
                      );
                      pickupDetails = Pickupdetailsmodel(
                          address: pickupAddress.text,
                          name: pickupName.text,
                          phoneNo: pickupphone.text);
                      Navigator.pop(context, true);
                    } else {
                      print('it is empty');
                      Future.delayed(Duration(seconds: 0), () {
                        setState(() {
                          _visible = !_visible;
                        });
                        Future.delayed(Duration(seconds: 2), () {
                          setState(() {
                            _visible = !_visible;
                          });
                        });
                      });
                    }
                  }
                  if (widget.bottomModalSheetfor == 'drop') {
                    if (dropphone.text.isNotEmpty ||
                        dropName.text.isNotEmpty ||
                        dropAddress.text.isNotEmpty) {
                      Provider.of<AppInfo>(context, listen: false)
                          .userDropDetails(
                        Dropdetailsmodel(
                            address: dropAddress.text,
                            name: dropName.text,
                            phoneNo: dropphone.text),
                      );
                      dropDetails = Dropdetailsmodel(
                          address: dropAddress.text,
                          name: dropName.text,
                          phoneNo: dropphone.text);
                      Navigator.pop(context, true);
                    } else {
                      print('it is empty');
                      Future.delayed(Duration(seconds: 0), () {
                        setState(() {
                          _visible = !_visible;
                        });
                        Future.delayed(Duration(seconds: 2), () {
                          setState(() {
                            _visible = !_visible;
                          });
                        });
                      });
                    }
                  }
                },
                child: Container(
                  width: _width * 0.8,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
