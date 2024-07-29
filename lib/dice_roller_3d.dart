import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:simple_roll_dice/dice_3d.dart';
import 'package:simple_roll_dice/dice_roller.dart';

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
  late AnimationController _controller;
  late CurvedAnimation _curvedAnimation;
  late Animation<Vector3> _animation;
  late Vector3Tween _rotationTween;

  // ONE is facing camera
  final Map<int, List<double>> faceRotations = {
    1: [0, 0, 0],
    2: [-90, 0, 0],
    3: [0, 90, 0],
    4: [0, -90, 0],
    5: [90, 0, 0],
    6: [180, 0, 0],
  };
  int _face = 1;
  int _prevFace = 1;
  Vector3 _currentRotation = Vector3.zero();
  Vector3 _rotation = Vector3.zero();

  bool _isLoading = true;
  bool _isRolling = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.milliseconds),
      vsync: this,
    );

    _rotationTween = Vector3Tween(
      begin: Vector3.zero(),
      end: Vector3.zero(),
    );

    _curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _animation = _rotationTween.animate(_curvedAnimation)
      ..addListener(_onAnimationUpdate)
      ..addStatusListener(_onAnimationStatusChange);

    _face = 1 + randomizer.nextInt(6);
    _prevFace = _face;
    _currentRotation = Vector3.array(faceRotations[_face]!);
    _rotation = Vector3.copy(_currentRotation);

    debugPrint('Initial face: $_face');
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
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
            rotation: _rotation,
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
    // debugPrint('Animation value: ${_animation.value}');
    setState(() {
      _rotation = _animation.value;
    });
  }

  void _onAnimationStatusChange(AnimationStatus status) {
    // debugPrint('Animation status: $status');
    if (status == AnimationStatus.completed) {
      _currentRotation = _rotation;
      _isRolling = false;
    }
  }

  void _onDiceCreated(Object dice) {
    setState(() {
      _isLoading = false;
    });
  }

  void _rollDice() {
    if (_isLoading || _isRolling) {
      return;
    }

    _isRolling = true;
    _prevFace = _face;
    //_face = _face == 6 ? 1 : _face + 1;
    while (_face == _prevFace) {
      _face = 1 + randomizer.nextInt(6);
    }

    debugPrint('Rolling dice from $_prevFace to $_face');
    Vector3 targetRotation = Vector3.array(faceRotations[_face]!);
    Vector3 rotationDelta = targetRotation - _currentRotation;
    rotationDelta = Vector3(
      _nomalizeAngle(rotationDelta.x),
      _nomalizeAngle(rotationDelta.y),
      _nomalizeAngle(rotationDelta.z),
    );

    _rotationTween.begin = _currentRotation;
    _rotationTween.end = _currentRotation + rotationDelta;

    _controller.forward(from: 0);
  }

  double _nomalizeAngle(double angle) {
    // normalize angle to -180 to 180
    while (angle < -180) {
      angle += 360;
    }
    while (angle > 180) {
      angle -= 360;
    }

    return angle;
  }
}

class Vector3Tween extends Tween<Vector3> {
  Vector3Tween({required Vector3 begin, required Vector3 end})
      : super(begin: begin, end: end);

  @override
  Vector3 lerp(double t) {
    return Vector3(
      begin!.x + (end!.x - begin!.x) * t,
      begin!.y + (end!.y - begin!.y) * t,
      begin!.z + (end!.z - begin!.z) * t,
    );
  }
}
