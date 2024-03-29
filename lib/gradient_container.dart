// ignore_for_file: unused_import

import 'dart:math';

import 'package:flutter/material.dart';

import 'package:simple_roll_dice/app_localizations_delegate.dart';
import 'package:simple_roll_dice/dice_image.dart';
import 'package:simple_roll_dice/dice_roller.dart';
import 'package:simple_roll_dice/styled_text.dart';

class GradientContainer extends StatelessWidget {
  final List<Color> colors;

  const GradientContainer({super.key, required this.colors});

  const GradientContainer.purple({super.key})
      : colors = const [Colors.purple, Colors.deepPurple];

  @override
  Widget build(BuildContext context) {
    final _ = AppLocalizations.of(context);

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
            StyledText(_.translate('txt_app_title')),
            const DiceRoller(),
          ],
        ),
      ),
    );
  }
}
