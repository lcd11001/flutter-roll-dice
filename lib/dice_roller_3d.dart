import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';

import 'package:simple_roll_dice/dice_3d.dart';
import 'package:simple_roll_dice/dice_roller.dart';

typedef DiceRoller3DCallback = void Function(DiceRoller3D roller);

class DiceRoller3D extends StatefulWidget {
  final String fileName;
  final int milliseconds;
  final int numberOfRolls;
  final int initFace;
  final VoidCallback? onPressed;
  final DiceRoller3DCallback? onCreated;
  final Color? bgColor;
  final double width = 150.0;
  final double height = 150.0;

  late final _DiceRoller3DState _state;

  DiceRoller3D({
    super.key,
    required this.fileName,
    this.milliseconds = 2000,
    this.numberOfRolls = 3,
    this.initFace = 1,
    this.onPressed,
    this.onCreated,
    this.bgColor = Colors.transparent,
  }) {
    _state = _DiceRoller3DState();
  }

  void rollDice() {
    _state._rollDice();
  }

  @override
  State<DiceRoller3D> createState() => _state;
}

class _DiceRoller3DState extends State<DiceRoller3D>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _curvedAnimation;
  late final Animation<Vector3> _animation;
  late final Vector3Tween _rotationTween;

  // ONE is facing camera
  static const Map<int, List<double>> faceRotations = {
    1: [0, 0, 0],
    2: [-90, 0, 0],
    3: [0, 90, 0],
    4: [0, -90, 0],
    5: [90, 0, 0],
    6: [180, 0, 0],
  };
  int _targetFace = 1;
  int _prevFace = 1;
  int _currentFace = 1;
  Vector3 _currentRotation = Vector3.zero();
  Vector3 _rotation = Vector3.zero();

  bool _isLoading = true;
  bool _isRolling = false;
  int _rollCount = 0;

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

    //_targetFace = 1 + randomizer.nextInt(6);
    _targetFace = widget.initFace;
    _prevFace = _currentFace = _targetFace;
    _currentRotation = Vector3.array(faceRotations[_targetFace]!);
    _rotation = Vector3.copy(_currentRotation);

    debugPrint('Initial face: $_targetFace');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        GestureDetector(
          onTap: () {
            widget.onPressed?.call();
            _rollDice();
          },
          child: Container(
            color: widget.bgColor,
            width: widget.width,
            height: widget.height,
            child: Dice3D(
              fileName: widget.fileName,
              rotation: _rotation,
              scale: Vector3.all(3),
              isAsset: true,
              onCreated: _onDiceCreated,
            ),
          ),
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
      _prevFace = _currentFace;

      if (_rollCount < widget.numberOfRolls) {
        _performSingleRoll();
      } else {
        _isRolling = false;
      }
    }
  }

  void _onDiceCreated(Object dice) {
    setState(() {
      _isLoading = false;
      widget.onCreated?.call(widget);
    });
  }

  void _rollDice() {
    if (_isLoading || _isRolling) {
      return;
    }

    _isRolling = true;
    _prevFace = _currentFace = _targetFace;
    //_targetFace = _targetFace == 6 ? 1 : _targetFace + 1;
    while (_targetFace == _prevFace) {
      _targetFace = 1 + randomizer.nextInt(6);
    }
    debugPrint('>>>>>>> Rolling dice from $_prevFace to $_targetFace');

    _rollCount = 0;
    _performSingleRoll();
  }

  void _performSingleRoll() {
    _rollCount++;

    if (_rollCount == widget.numberOfRolls) {
      _currentFace = _targetFace;
    } else {
      while (_currentFace == _prevFace ||
          (_currentFace == _targetFace &&
              _rollCount == widget.numberOfRolls - 1)) {
        _currentFace = 1 + randomizer.nextInt(6);
      }
    }

    debugPrint('  #$_rollCount: Rolling dice from $_prevFace to $_currentFace');

    Vector3 targetRotation = Vector3.array(faceRotations[_currentFace]!);
    Vector3 rotationDelta = targetRotation - _currentRotation;
    rotationDelta = _nomalizeRotation(rotationDelta);

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

  Vector3 _nomalizeRotation(Vector3 vector) {
    return Vector3(
      _nomalizeAngle(vector.x),
      _nomalizeAngle(vector.y),
      _nomalizeAngle(vector.z),
    );
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
