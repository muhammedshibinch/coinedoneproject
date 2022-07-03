import 'package:flutter/material.dart';

import 'colorconstants.dart';

class Utils {
  TextStyle textStyle(
      {double fontSize = 20,
      dynamic fontWeight = FontWeight.w500,
      Color color = black}) {
    return TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontFamily: 'Euclid',
        color: color);
  }
}
