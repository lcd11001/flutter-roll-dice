import 'dart:math';

import 'package:first_app/dice_image.dart';
import 'package:flutter/material.dart';

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
    return Center(
      child: Column(children: [
        DiceImage(
          imagePath: 'assets/dice-images/dice-${diceNumber + 1}.png',
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
          child: const Text('Roll Dice'),
        )
      ]),
    );
  }
}

typedef RollDiceCallback = void Function();
