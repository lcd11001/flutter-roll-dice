import 'package:flutter/material.dart';

import 'package:simple_roll_dice/gradient_container.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        //body: GradientContainer(colors: [Colors.blue, Colors.green]),
        body: GradientContainer.purple(),
      ),
    ),
  );
}
