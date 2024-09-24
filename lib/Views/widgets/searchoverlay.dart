import 'package:flutter/material.dart';

void createOverlayofPredictedPlaces(BuildContext context,
    {LayerLink? link, Function? ontap}) {
  OverlayEntry entry;
  entry = OverlayEntry(
    builder: (context) {
      return CompositedTransformFollower(
        link: link!,
        showWhenUnlinked: false,
        child: Material(
          elevation: 4.0,
          child: Container(
            color: Colors.white,
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Place $index'),
                  onTap: () {
                    ontap;
                  },
                );
              },
            ),
          ),
        ),
      );
    },
  );
}
