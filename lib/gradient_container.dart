// ignore_for_file: unused_import

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:simple_roll_dice/dice_image.dart';
import 'package:simple_roll_dice/dice_roller.dart';
import 'package:simple_roll_dice/dice_roller_3d.dart';
import 'package:simple_roll_dice/result_text.dart';
import 'package:simple_roll_dice/styled_text.dart';

class GradientContainer extends StatefulWidget {
  final List<Color> colors;

  const GradientContainer({super.key, required this.colors});

  const GradientContainer.purple({super.key})
      : colors = const [Colors.purple, Colors.deepPurple];

  @override
  State<GradientContainer> createState() => _GradientContainerState();
}

const int _numberOfRolls = 5;
const int _milliseconds = 300;
const int _resultDuration = 2000;

class _GradientContainerState extends State<GradientContainer> {
  List<DiceRoller3D> _diceRollers = [];
  int _isLoading = 3;
  int _isRolling = 3;
  int _diceNumber = 0;
  bool _showResult = false;

  @override
  void initState() {
    super.initState();

    _diceRollers = [
      DiceRoller3D(
        fileName: 'assets/dice-3d/cube.obj',
        milliseconds: _milliseconds,
        numberOfRolls: _numberOfRolls,
        onCreated: _onDiceCreated,
        onRollCompleted: _onDiceRollCompleted,
      ),
      DiceRoller3D(
        fileName: 'assets/dice-3d/cube.obj',
        milliseconds: _milliseconds,
        numberOfRolls: _numberOfRolls,
        onCreated: _onDiceCreated,
        onRollCompleted: _onDiceRollCompleted,
      ),
      DiceRoller3D(
        fileName: 'assets/dice-3d/cube.obj',
        milliseconds: _milliseconds,
        numberOfRolls: _numberOfRolls,
        onCreated: _onDiceCreated,
        onRollCompleted: _onDiceRollCompleted,
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
        child: Stack(
          children: [
            Center(
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
                    onPressed: _onRollDice,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                      textStyle: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text(_isLoading > 0 ? "..." : loc.txt_btn_roll),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
            if (_showResult)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: ResultText(text: '$_diceNumber'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _onRollDice() {
    setState(() {
      _diceNumber = 0;
      _isRolling = 3;
      _showResult = false;
      for (final diceRoller in _diceRollers) {
        diceRoller.rollDice();
      }
    });
  }

  void _onDiceCreated(DiceRoller3D roller) {
    setState(() {
      _isLoading--;
    });
  }

  void _onDiceRollCompleted(int face) {
    setState(() {
      _isRolling--;
      _diceNumber += face;
      _showResult = _isRolling == 0;
    });

    if (_isRolling == 0) {
      debugPrint('Dice number: $_diceNumber');
      Timer.periodic(const Duration(milliseconds: _resultDuration), (timer) {
        setState(() {
          _showResult = false;
        });
        timer.cancel();
      });
    }
  }
}
