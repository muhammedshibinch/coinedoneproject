import 'package:flutter/material.dart';

import '../../utils/colorconstants.dart';

class Dash extends StatelessWidget {
  const Dash({Key? key, this.height = 1, this.width = 2}) : super(key: key);
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final dashWidth = width;
        final dashHeight = height;
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.vertical,
          children: List.generate(4, (_) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 1),
              width: dashWidth,
              height: dashHeight,
              child: const DecoratedBox(
                decoration: BoxDecoration(color: dashColor),
              ),
            );
          }),
        );
      },
    );
  }
}
