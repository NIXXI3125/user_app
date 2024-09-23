import 'package:flutter/material.dart';

class DotWidget extends StatelessWidget {
  final double totalHeight, dashWidth, emptyWidth, dashHeight;

  final Color dashColor;

  const DotWidget({
    this.totalHeight = 25,
    this.dashWidth = 15,
    this.emptyWidth = 3,
    this.dashHeight = 5,
    this.dashColor = Colors.white,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: List.generate(
        totalHeight ~/ (dashHeight + emptyWidth),
        (_) => Container(
          width: dashHeight,
          height: dashWidth,
          margin: EdgeInsets.only(top: emptyWidth / 2, bottom: emptyWidth / 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dashColor,
          ),
        ),
      ),
    );
  }
}
