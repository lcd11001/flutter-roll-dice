import 'dart:math';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:simple_roll_dice/dice_image.dart';

final randomizer = Random();

class DiceRoller extends StatefulWidget {
  const DiceRoller({
    super.key,
  });

  @override
  State<DiceRoller> createState() => _DiceRollerState();
}

// underscore means private class
class _DiceRollerState extends State<DiceRoller> {
  late int diceNumber;

  @override
  void initState() {
    super.initState();
    diceNumber = 0;
  }

  void rollDice() {
    setState(() {
      diceNumber = randomizer.nextInt(6);
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Center(
      child: Column(children: [
        DiceImage(
          imagePath: 'assets/dice-3d/dice-${diceNumber + 1}.png',
        ),
        TextButton(
          onPressed: rollDice,
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
            backgroundColor: Colors.black,
            padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
            textStyle: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: Text(loc.txt_btn_roll),
        )
      ]),
    );
  }
}

typedef RollDiceCallback = void Function();
