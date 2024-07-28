import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'dart:math';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DiceRoller3D extends StatefulWidget {
  final int duration;
  const DiceRoller3D({super.key, this.duration = 1000});

  @override
  State<DiceRoller3D> createState() => _DiceRoller3DState();
}

class _DiceRoller3DState extends State<DiceRoller3D>
    with SingleTickerProviderStateMixin {
  late Scene scene;
  Object? dice;
  final randomizer = Random();
  late AnimationController controller;
  late Animation<double> animation;
  late bool isLoading;

  int face = 3;

  double angleX = 0;
  double angleY = 0;
  double angleZ = 0;

  double targetAngleX = 0;
  double targetAngleY = 0;
  double targetAngleZ = 0;

  // One facing camera
  final Map<int, List<double>> faceRotationsOne = {
    1: [0, 0, 0],
    2: [-90, 0, 0],
    3: [0, 90, 0],
    4: [0, -90, 0],
    5: [90, 0, 0],
    6: [180, 0, 0],
  };

  // Two facing camera
  final Map<int, List<double>> faceRotationsTwo = {
    1: [90, 0, 0],
    2: [0, 0, 0],
    3: [0, 90, 0],
    4: [0, -90, 0],
    5: [180, 0, 0],
    6: [-90, 0, 0],
  };

  // Three facing camera
  final Map<int, List<double>> faceRotationsThree = {
    1: [0, -90, 0],
    2: [-90, -90, 0],
    3: [0, 0, 0],
    4: [0, 180, 0],
    5: [90, -90, 0],
    6: [180, -90, 0],
  };

  // Four facing camera
  final Map<int, List<double>> faceRotationsFour = {
    1: [0, 90, 0],
    2: [-90, 90, 0],
    3: [0, 180, 0],
    4: [0, 0, 0],
    5: [90, 90, 0],
    6: [180, 90, 0],
  };

  // Five facing camera
  final Map<int, List<double>> faceRotationsFive = {
    1: [-90, 0, 0],
    2: [180, 0, 0],
    3: [90, 90, 0],
    4: [90, -90, 0],
    5: [0, 0, 0],
    6: [90, 0, 0],
  };

  // Six facing camera
  final Map<int, List<double>> faceRotationsSix = {
    1: [180, 0, 0],
    2: [90, 0, 0],
    3: [180, 90, 0],
    4: [180, -90, 0],
    5: [-90, 0, 0],
    6: [0, 0, 0],
  };

  Map<int, List<double>> calculateFaceRotations(int facingCamera) {
    // Helper function to normalize angles to the range [0, 360)
    double normalizeAngle(double angle) {
      while (angle < 0) angle += 360;
      return angle % 360;
    }

    // Helper function to create a rotation
    List<double> createRotation(double x, double y, double z) {
      return [normalizeAngle(x), normalizeAngle(y), normalizeAngle(z)];
    }

    switch (facingCamera) {
      case 1:
        return {
          1: createRotation(0, 0, 0),
          2: createRotation(90, 0, 0),
          3: createRotation(0, 90, 0),
          4: createRotation(0, -90, 0),
          5: createRotation(-90, 0, 0),
          6: createRotation(180, 0, 0),
        };
      case 2:
        return {
          1: createRotation(-90, 0, 0),
          2: createRotation(0, 0, 0),
          3: createRotation(0, 90, 0),
          4: createRotation(0, -90, 0),
          5: createRotation(180, 0, 0),
          6: createRotation(90, 0, 0),
        };
      case 3:
        return {
          1: createRotation(0, -90, 0),
          2: createRotation(90, 0, -90),
          3: createRotation(0, 0, 0),
          4: createRotation(0, 180, 0),
          5: createRotation(-90, 0, -90),
          6: createRotation(180, 0, -90),
        };
      case 4:
        return {
          1: createRotation(0, 90, 0),
          2: createRotation(90, 0, 90),
          3: createRotation(0, 180, 0),
          4: createRotation(0, 0, 0),
          5: createRotation(-90, 0, 90),
          6: createRotation(180, 0, 90),
        };
      case 5:
        return {
          1: createRotation(90, 0, 0),
          2: createRotation(180, 0, 0),
          3: createRotation(90, 90, 0),
          4: createRotation(90, -90, 0),
          5: createRotation(0, 0, 0),
          6: createRotation(-90, 0, 0),
        };
      case 6:
        return {
          1: createRotation(180, 0, 0),
          2: createRotation(-90, 0, 0),
          3: createRotation(180, 90, 0),
          4: createRotation(180, -90, 0),
          5: createRotation(90, 0, 0),
          6: createRotation(0, 0, 0),
        };
      default:
        throw ArgumentError('Invalid face number. Must be between 1 and 6.');
    }
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
    controller = AnimationController(
      duration: Duration(milliseconds: widget.duration),
      vsync: this,
    )..addListener(_onValueChanged);

    animation = Tween<double>(begin: 0, end: 1)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(controller);

    // animation = TweenSequence<double>([
    //   TweenSequenceItem<double>(
    //     tween: Tween<double>(begin: 0, end: 360)
    //         .chain(CurveTween(curve: Curves.easeIn)),
    //     weight: 1,
    //   ),
    //   TweenSequenceItem<double>(
    //     tween: Tween<double>(begin: 360, end: 0)
    //         .chain(CurveTween(curve: Curves.easeOut)),
    //     weight: 1,
    //   ),
    // ]).animate(controller);
  }

  @override
  void dispose() {
    controller.removeListener(_onValueChanged);
    controller.dispose();
    super.dispose();
  }

  void _onValueChanged() {
    if (dice != null) {
      double newAngleX = angleX + targetAngleX * animation.value;
      double newAngleY = angleY + targetAngleY * animation.value;
      double newAngleZ = angleZ + targetAngleZ * animation.value;
      //debugPrint('angleX: $angleX angleY: $angleY angleZ: $angleZ');

      dice!.rotation.setValues(newAngleX, newAngleY, newAngleZ);

      dice!.updateTransform();
      scene.update();
    }
  }

  void _onSceneCreated(Scene scene) {
    this.scene = scene;

    scene.camera.position.z = 3;

    //List<double> rotations = _getRotations(1, face);
    List<double> rotations = calculateFaceRotations(face)[face]!;

    dice = Object(
      position: Vector3(0, 0, 0),
      rotation: Vector3(rotations[0], rotations[1], rotations[2]),
      scale: Vector3(1, 1, 1),
      fileName: 'assets/dice-3d/cube.obj',
      backfaceCulling: false,
    );

    scene.world.add(dice!);
  }

  List<double> _getRotations(int face, int newFace) {
    switch (face) {
      case 1:
        return faceRotationsOne[newFace]!;

      case 2:
        return faceRotationsTwo[newFace]!;

      case 3:
        return faceRotationsThree[newFace]!;

      case 4:
        return faceRotationsFour[newFace]!;

      case 5:
        return faceRotationsFive[newFace]!;

      case 6:
        return faceRotationsSix[newFace]!;
    }
    return faceRotationsOne[newFace]!;
  }

  void rollDice() {
    int newFace = face;
    while (true) {
      newFace = randomizer.nextInt(6) + 1;
      if (face != newFace) {
        debugPrint('oldFace: $face newFace: $newFace');
        break;
      }
    }

    setState(() {
      // debug
      //int newFace = 1;
      angleX = dice!.rotation.x;
      angleY = dice!.rotation.y;
      angleZ = dice!.rotation.z;

      //List<double> rotations = _getRotations(face, newFace);
      List<double> rotations = calculateFaceRotations(face)[newFace]!;
      targetAngleX = rotations[0];
      targetAngleY = rotations[1];
      targetAngleZ = rotations[2];

      face = newFace;
    });

    controller.reset();
    controller.forward();
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
          child: Cube(
            onSceneCreated: _onSceneCreated,
            onObjectCreated: _onObjectCreated,
            interactive: true,
          ),
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
          child: Text(isLoading ? "loading" : loc.txt_btn_roll),
        ),
      ],
    );
  }

  void _onObjectCreated(Object object) {
    if (object.children.isNotEmpty) {
      setState(() {
        isLoading = false;
      });
    }
  }
}
