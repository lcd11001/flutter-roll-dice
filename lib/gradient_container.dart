// ignore_for_file: unused_import

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:simple_roll_dice/dice_image.dart';
import 'package:simple_roll_dice/dice_roller.dart';
import 'package:simple_roll_dice/dice_roller_3d.dart';
import 'package:simple_roll_dice/styled_text.dart';

class GradientContainer extends StatelessWidget {
  final List<Color> colors;

  const GradientContainer({super.key, required this.colors});

  const GradientContainer.purple({super.key})
      : colors = const [Colors.purple, Colors.deepPurple];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StyledText(loc.txt_app_title),
            // const DiceRoller(),
            const DiceRoller3D(
              fileName: 'assets/dice-3d/cube.obj',
            ),
          ],
        ),
      ),
    );
  }
}
