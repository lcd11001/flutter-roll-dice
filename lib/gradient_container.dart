// ignore_for_file: unused_import

import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

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

const int _dropDuration = 1000;
const double _dropHeight = -500;

final randomizer = Random();

class _GradientContainerState extends State<GradientContainer>
    with SingleTickerProviderStateMixin {
  List<DiceRoller3D> _diceRollers = [];
  int _isLoading = 3;
  int _isRolling = 0;
  int _diceNumber = 0;
  bool _showResult = false;
  double _diceVerticalPosition = -100.0;
  late AnimationController _diceAnimationController;
  late Animation<double> _diceAnimation;
  late Future googleFontsPending;

  @override
  void initState() {
    super.initState();

    googleFontsPending = GoogleFonts.pendingFonts([
      GoogleFonts.yesevaOne(),
    ]);

    _diceAnimationController = AnimationController(
      duration: const Duration(milliseconds: _dropDuration),
      vsync: this,
    );

    _diceAnimation = Tween<double>(begin: _dropHeight, end: 0.0).animate(
      CurvedAnimation(
        parent: _diceAnimationController,
        curve: Curves.bounceOut,
      ),
    )..addListener(() {
        _diceVerticalPosition = _diceAnimation.value;
      });

    _diceRollers = [
      DiceRoller3D(
        fileName: 'assets/dice-3d/cube.obj',
        milliseconds: _milliseconds,
        numberOfRolls: _numberOfRolls,
        initFace: randomizer.nextInt(6) + 1,
        onCreated: _onDiceCreated,
        onRollCompleted: _onDiceRollCompleted,
      ),
      DiceRoller3D(
        fileName: 'assets/dice-3d/cube.obj',
        milliseconds: _milliseconds,
        numberOfRolls: _numberOfRolls,
        initFace: randomizer.nextInt(6) + 1,
        onCreated: _onDiceCreated,
        onRollCompleted: _onDiceRollCompleted,
      ),
      DiceRoller3D(
        fileName: 'assets/dice-3d/cube.obj',
        milliseconds: _milliseconds,
        numberOfRolls: _numberOfRolls,
        initFace: randomizer.nextInt(6) + 1,
        onCreated: _onDiceCreated,
        onRollCompleted: _onDiceRollCompleted,
      ),
    ];
  }

  @override
  void dispose() {
    _diceAnimationController.dispose();
    super.dispose();
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
                          AnimatedBuilder(
                            animation: _diceAnimationController,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(0, _diceVerticalPosition),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: maxDiceWidth,
                                  ),
                                  child: diceRoller,
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                  FutureBuilder(
                    future: googleFontsPending,
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const SizedBox();
                      }

                      return TextButton(
                        //onPressed: _rollDice,
                        onPressed: _onRollDice,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                          minimumSize: const Size(200, 40),
                          textStyle: GoogleFonts.getFont("Yeseva One").copyWith(
                            fontSize: 30,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        child: Text(_isLoading > 0 ? "..." : loc.txt_btn_roll),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
            if (_showResult)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: ResultText(
                    number: _diceNumber,
                    onCompleted: _onShowResultCompleted,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _onRollDice() {
    if (_isLoading > 0) {
      debugPrint('Still loading');
      return;
    }

    if (_isRolling > 0) {
      debugPrint('Still rolling');
      return;
    }

    if (_showResult) {
      debugPrint('Still showing result');
      return;
    }

    setState(() {
      _diceNumber = 0;
      _isRolling = 3;
      _showResult = false;
    });

    _diceAnimationController.forward(from: 0.0);

    for (final diceRoller in _diceRollers) {
      diceRoller.rollDice();
    }
  }

  void _onDiceCreated(DiceRoller3D roller) {
    setState(() {
      _isLoading--;
    });

    if (_isLoading == 0) {
      _diceAnimationController.forward(from: 0.0);
    }
  }

  void _onDiceRollCompleted(int face) {
    setState(() {
      _isRolling--;
      _diceNumber += face;
      _showResult = _isRolling == 0;
    });
  }

  void _onShowResultCompleted(PlayerState state) {
    if (state == PlayerState.completed) {
      setState(() {
        _showResult = false;
      });
    }
  }
}
