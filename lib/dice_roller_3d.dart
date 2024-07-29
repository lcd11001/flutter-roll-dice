import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:simple_roll_dice/dice_3d.dart';

class DiceRoller3D extends StatefulWidget {
  final String fileName;
  final int milliseconds;

  const DiceRoller3D({
    super.key,
    required this.fileName,
    this.milliseconds = 2000,
  });

  @override
  State<DiceRoller3D> createState() => _DiceRoller3DState();
}

class _DiceRoller3DState extends State<DiceRoller3D>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.milliseconds),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(_onAnimationUpdate)
      ..addStatusListener(_onAnimationStatusChange);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          width: 300,
          height: 300,
          child: Dice3D(
            fileName: widget.fileName,
            scale: Vector3.all(2),
            isAsset: true,
            onCreated: _onDiceCreated,
          ),
        ),
        TextButton(
          onPressed: _rollDice,
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
            backgroundColor: Colors.black,
            padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
            textStyle: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: Text(_isLoading ? "loading" : loc.txt_btn_roll),
        ),
      ],
    );
  }

  void _onAnimationUpdate() {
    debugPrint('Animation value: ${_animation.value}');
  }

  void _onAnimationStatusChange(AnimationStatus status) {
    debugPrint('Animation status: $status');
  }

  void _onDiceCreated(Object dice) {
    setState(() {
      _isLoading = false;
    });
  }

  void _rollDice() {
    if (_isLoading) {
      return;
    }

    _controller.forward(from: 0);
  }
}
