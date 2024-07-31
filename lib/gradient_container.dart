// ignore_for_file: unused_import

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:simple_roll_dice/dice_image.dart';
import 'package:simple_roll_dice/dice_roller.dart';
import 'package:simple_roll_dice/dice_roller_3d.dart';
import 'package:simple_roll_dice/styled_text.dart';

class GradientContainer extends StatefulWidget {
  final List<Color> colors;

  const GradientContainer({super.key, required this.colors});

  const GradientContainer.purple({super.key})
      : colors = const [Colors.purple, Colors.deepPurple];

  @override
  State<GradientContainer> createState() => _GradientContainerState();
}

class _GradientContainerState extends State<GradientContainer> {
  List<DiceRoller3D> _diceRollers = [];
  int _isLoading = 3;

  @override
  void initState() {
    super.initState();

    _diceRollers = [
      DiceRoller3D(
        fileName: 'assets/dice-3d/cube.obj',
        milliseconds: 1000,
        numberOfRolls: 5,
        onCreated: _onDiceCreated,
      ),
      DiceRoller3D(
        fileName: 'assets/dice-3d/cube.obj',
        milliseconds: 1000,
        numberOfRolls: 5,
        onCreated: _onDiceCreated,
      ),
      DiceRoller3D(
        fileName: 'assets/dice-3d/cube.obj',
        milliseconds: 1000,
        numberOfRolls: 5,
        onCreated: _onDiceCreated,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    // Adjust the width as needed
    final maxDiceWidth = MediaQuery.of(context).size.width / 2 - 16;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.colors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              StyledText(loc.txt_app_title),
              Expanded(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  spacing: 8.0, // Horizontal spacing between children
                  runSpacing: 8.0, // Vertical spacing between runs
                  children: [
                    for (final diceRoller in _diceRollers)
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: maxDiceWidth,
                          ),
                          child: diceRoller,
                        ),
                      ),
                  ],
                ),
              ),
              TextButton(
                //onPressed: _rollDice,
                onPressed: () {
                  // how I can call DiceRoller3D._rollDice when TextButton have pressed?
                  debugPrint('TextButton onPressed');
                  for (final diceRoller in _diceRollers) {
                    diceRoller.rollDice();
                  }
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                  textStyle: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Text(_isLoading > 0 ? "loading" : loc.txt_btn_roll),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _onDiceCreated(DiceRoller3D roller) {
    setState(() {
      _isLoading--;
    });
  }
}
