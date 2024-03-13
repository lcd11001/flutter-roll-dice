import 'package:flutter/material.dart';

class DiceImage extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;

  const DiceImage(
      {super.key,
      required this.imagePath,
      this.width = 200,
      this.height = 200});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      width: width,
      height: height,
    );
  }
}
