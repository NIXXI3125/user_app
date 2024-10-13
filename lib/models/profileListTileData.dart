import 'package:flutter/material.dart';

class Profilelisttiledata {
  final String title;
  final IconData leadingIcon;
  final void Function() onTap;
  final Color? iconColor;

  const Profilelisttiledata(
      {required this.title,
      required this.leadingIcon,
      required this.onTap,
      this.iconColor});
}
