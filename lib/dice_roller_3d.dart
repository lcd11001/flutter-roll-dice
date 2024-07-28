import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'dart:math';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DiceRoller3D extends StatefulWidget {
  const DiceRoller3D({super.key});

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

  @override
  void initState() {
    super.initState();
    isLoading = true;
    controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..addListener(_onValueChanged);

    // animation = Tween<double>(begin: 0, end: 360).animate(controller);
    animation = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: 360)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 1,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 360, end: 0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 1,
      ),
    ]).animate(controller);
  }

  @override
  void dispose() {
    controller.removeListener(_onValueChanged);
    controller.dispose();
    super.dispose();
  }

  void _onValueChanged() {
    if (dice != null) {
      double angle = animation.value;
      //debugPrint('value: ${controller.value} angle: $angle');

      dice!.rotation.y = angle;

      dice!.updateTransform();
      scene.update();
    }
  }

  void _onSceneCreated(Scene scene) {
    this.scene = scene;

    scene.camera.position.z = 3;

    dice = Object(
      position: Vector3(0, 0, 0),
      scale: Vector3(1, 1, 1),
      fileName: 'assets/dice-3d/cube.obj',
      backfaceCulling: false,
    );

    scene.world.add(dice!);
  }

  void rollDice() {
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
