// ignore_for_file: unused_import

import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:simple_roll_dice/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:simple_roll_dice/dice_image.dart';
import 'package:simple_roll_dice/dice_roller.dart';
import 'package:simple_roll_dice/dice_roller_3d.dart';
import 'package:simple_roll_dice/providers/provider_settings.dart';
import 'package:simple_roll_dice/result_text.dart';
import 'package:simple_roll_dice/styled_text.dart';
import 'package:simple_roll_dice/widgets/ads/ads_banner.dart';
import 'package:simple_roll_dice/widgets/settings_popup.dart';

class GradientContainer extends ConsumerStatefulWidget {
  final List<Color> colors;

  const GradientContainer({super.key, required this.colors});

  const GradientContainer.purple({super.key})
    : colors = const [Colors.purple, Colors.deepPurple];

  @override
  ConsumerState<GradientContainer> createState() => _GradientContainerState();
}

const int _numberOfRolls = 5;
const int _milliseconds = 300;

const double _dropHeight = -500;
const double _dropGround = -200;

final randomizer = Random();

class _GradientContainerState extends ConsumerState<GradientContainer>
    with SingleTickerProviderStateMixin {
  late int _isLoading;

  int _isRolling = 0;
  int _dicePoints = 0;
  bool _showResult = false;
  double _diceVerticalPosition = -100.0;
  final List<DiceRoller3DState> _diceRollers = List.empty(growable: true);

  late final AudioPlayer _audioDiceRolling;
  late final AudioPlayer _audioDiceSingleRolling;

  late final AnimationController _diceAnimationController;
  late final Animation<double> _diceAnimation;
  late final Future googleFontsPending;
  late int _dropDuration;

  @override
  void initState() {
    super.initState();

    final settings = ref.read(settingsProvider);

    _isLoading = settings.numberDices;
    _dropDuration = _numberOfRolls * _milliseconds;

    googleFontsPending = GoogleFonts.pendingFonts([GoogleFonts.yesevaOne()]);

    _audioDiceRolling = AudioPlayer();
    _audioDiceRolling.setSourceAsset("sounds/dice_rolling.mp3");
    _audioDiceRolling.setReleaseMode(ReleaseMode.stop);

    // AudioPool.createFromAsset(path: "sounds/dice_rolling.mp3", maxPlayers: 2)
    //     .then((pool) {
    //   _audioDiceRolling = pool;
    // });

    _audioDiceSingleRolling = AudioPlayer();
    _audioDiceSingleRolling.setSourceAsset("sounds/dice_single_rolling.mp3");
    _audioDiceSingleRolling.setReleaseMode(ReleaseMode.stop);
    // AudioPool.createFromAsset(
    //         path: "sounds/dice_single_rolling.mp3", maxPlayers: 2)
    //     .then((pool) {
    //   _audioDiceSingleRolling = pool;
    // });

    _diceAnimationController = AnimationController(
      duration: Duration(milliseconds: _dropDuration),
      vsync: this,
    );

    _diceAnimation = Tween<double>(begin: _dropHeight, end: 0.0).animate(
      CurvedAnimation(
        parent: _diceAnimationController,
        curve: Curves.bounceOut,
      ),
    )..addListener(() {
      _diceVerticalPosition = _diceAnimation.value;
      // debugPrint('Dice vertical position: $_diceVerticalPosition');
    });
  }

  @override
  void dispose() {
    _diceAnimationController.dispose();
    _audioDiceRolling.dispose();
    _audioDiceSingleRolling.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    // Adjust the width as needed
    final double screenWidth = MediaQuery.of(context).size.width;
    final double maxDiceWidth = max(0.0, screenWidth / 2 - 16);
    debugPrint('Max dice width: $maxDiceWidth, screen width: $screenWidth');

    if (screenWidth <= 0) {
      debugPrint('!!!!!!! invalid screen width: $screenWidth');
      return const SizedBox();
    }

    const double bottomSheetHeight = 40.0; // Height from ThemeData in app.dart
    const double adPadding = 10.0; // Optional extra space above BottomSheet

    // watch the settings provider state
    final settings = ref.watch(settingsProvider);

    return Stack(
      children: [
        Container(
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
                      children: buildDices(maxDiceWidth),
                    ),
                  ),
                  buildOptions(),
                  FutureBuilder(
                    future: googleFontsPending,
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const SizedBox();
                      }

                      return TextButton(
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
                  const AdsBanner(),
                  SizedBox(height: adPadding),
                ],
              ),
            ),
          ),
        ),
        if (_showResult)
          Container(
            color: Colors.black.withAlpha(128),
            child: Center(
              child: ResultText(
                number: _dicePoints,
                milisecondsDuration: settings.allowAudio ? 500 : 1500,
                onCompleted: _onShowResultCompleted,
              ),
            ),
          ),

        // show settings popup if needed
        if (settings.showSettings) const SettingsPopup(),
      ],
    );
  }

  List<Widget> buildDices(double maxDiceWidth) {
    final settings = ref.read(settingsProvider);
    return List.generate(settings.numberDices, (index) {
      return buildDice(maxDiceWidth);
    });
  }

  Widget buildDice(double maxDiceWidth) {
    return AnimatedBuilder(
      animation: _diceAnimationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _diceVerticalPosition),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxDiceWidth),
            child: DiceRoller3D(
              fileName: 'assets/dice-3d/cube.obj',
              milliseconds: _milliseconds,
              numberOfRolls: _numberOfRolls,
              initFace: randomizer.nextInt(6) + 1,
              onCreated: _onDiceCreated,
              onRollCompleted: _onDiceRollCompleted,
            ),
          ),
        );
      },
    );
  }

  void _onRollDice() {
    if (!isReady()) {
      debugPrint('Not ready');
      return;
    }
    final settings = ref.read(settingsProvider);
    _playSound(settings.numberDices);

    setState(() {
      _dicePoints = 0;
      _isRolling = settings.numberDices;
      _showResult = false;
    });

    _diceAnimationController.forward(from: 0.0);

    for (final diceRoller in _diceRollers) {
      diceRoller.rollDice();
    }
  }

  void _onDiceCreated(DiceRoller3DState state) {
    setState(() {
      _diceRollers.add(state);
      _isLoading--;
    });

    if (_isLoading == 0) {
      _diceAnimationController.forward(from: 1.0);
    }
  }

  void _onDiceRollCompleted(int face) {
    setState(() {
      _isRolling--;
      _dicePoints += face;
      _showResult = _isRolling == 0;
    });

    if (_showResult) {
      _stopSound();
    }
  }

  void _onShowResultCompleted(PlayerState state) {
    if (state == PlayerState.completed) {
      setState(() {
        _showResult = false;
      });
    }
  }

  buildOptions() {
    final settings = ref.read(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            Icons.remove,
            color:
                settings.numberDices == settings.minDices
                    ? Colors.grey
                    : Colors.white,
            size: 24,
          ),
          onPressed: () {
            if (settings.numberDices > settings.minDices && isReady()) {
              setState(() {
                _diceRollers.removeLast();
                //_numDice--;
                settingsNotifier.setNumberDices(settings.numberDices - 1);
              });
            }
          },
        ),
        Text(
          '${settings.numberDices}',
          style: GoogleFonts.getFont("Yeseva One").copyWith(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.add,
            color:
                settings.numberDices == settings.maxDices
                    ? Colors.grey
                    : Colors.white,
            size: 24,
          ),
          onPressed: () {
            if (settings.numberDices < settings.maxDices && isReady()) {
              setState(() {
                //_numDice++;
                settingsNotifier.setNumberDices(settings.numberDices + 1);
                _isLoading = 1;
              });
            }
          },
        ),
      ],
    );
  }

  bool isReady() {
    if (_isLoading > 0) {
      debugPrint('Still loading');
      return false;
    }

    if (_isRolling > 0) {
      debugPrint('Still rolling');
      return false;
    }

    if (_showResult) {
      debugPrint('Still showing result');
      return false;
    }

    return true;
  }

  Future<void> _playSound(int num) async {
    final settings = ref.read(settingsProvider);
    if (!settings.allowAudio) {
      return;
    }

    try {
      if (num == 1) {
        // await _audioDiceSingleRolling.start(volume: 1.0);
        Timer.periodic(const Duration(milliseconds: 50), (timer) {
          if (_diceVerticalPosition > _dropGround) {
            debugPrint('Play single rolling sound  at $_diceVerticalPosition');
            _audioDiceSingleRolling.resume();
            timer.cancel();
          }
        });
      } else {
        // await _audioDiceRolling.start(volume: 1.0);
        // _audioDiceRolling.resume();

        Timer.periodic(const Duration(milliseconds: 50), (timer) {
          if (_diceVerticalPosition > _dropGround) {
            debugPrint('Play rolling sound  at $_diceVerticalPosition');
            _audioDiceRolling.resume();
            timer.cancel();
          }
        });

        Timer.periodic(const Duration(milliseconds: 120), (timer) {
          if (_diceVerticalPosition > _dropGround) {
            debugPrint('Play single rolling sound at $_diceVerticalPosition');
            _audioDiceSingleRolling.resume();
            timer.cancel();
          }
        });
      }
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  Future<void> _stopSound() async {
    final settings = ref.read(settingsProvider);
    if (!settings.allowAudio) {
      return;
    }

    try {
      await _audioDiceRolling.stop();
      await _audioDiceSingleRolling.stop();
    } catch (e) {
      debugPrint('Error stopping sound: $e');
    }
  }
}
