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
  late bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..addListener(_onValueChanged);
  }

  @override
  void dispose() {
    controller.removeListener(_onValueChanged);
    controller.dispose();
    super.dispose();
  }

  void _onValueChanged() {
    debugPrint('value: ${controller.value}');
    // if (dice != null) {
    //   dice!.rotation.x = controller.value;
    //   dice!.rotation.y = controller.value;
    //   dice!.rotation.z = controller.value;
    // }
  }

  void _applyDiceImages() {
    // dice.children[0].texture = 'assets/dice-images/dice-1.png';
    // dice.children[1].texture = 'assets/dice-images/dice-2.png';
    // dice.children[2].texture = 'assets/dice-images/dice-3.png';
    // dice.children[3].texture = 'assets/dice-images/dice-4.png';
    // dice.children[4].texture = 'assets/dice-images/dice-5.png';
    // dice.children[5].texture = 'assets/dice-images/dice-6.png';
    debugPrint('dice.children.length: ${dice!.children.length}');
    debugPrint('dice.mesh.length: ${dice!.mesh}');

    // Load and apply the texture
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

    _applyDiceImages();

    scene.world.add(dice!);

    setState(() {
      isLoading = false;
    });
  }

  void rollDice() {
    setState(() {
      controller.value = 0;
    });
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
          child: Text(loc.txt_btn_roll),
        ),
      ],
    );
  }
}
