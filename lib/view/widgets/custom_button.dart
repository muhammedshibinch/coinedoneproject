import 'package:flutter/material.dart';

import '../../utils/colorconstants.dart';
import '../../utils/utils.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final void Function()? onTap;
  const CustomButton({Key? key, required this.title, required this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: primaryColor),
          onPressed: onTap,
          child: Text(title,
              style: Utils().textStyle(fontSize: 16, color: Colors.white))),
    );
  }
}
