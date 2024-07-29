import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';

class Dice3D extends StatefulWidget {
  final String fileName;
  final bool isAsset;
  final Vector3? position;
  final Vector3? rotation;
  final Vector3? scale;
  final void Function(Object)? onCreated;

  const Dice3D({
    super.key,
    required this.fileName,
    required this.isAsset,
    this.position,
    this.rotation,
    this.scale,
    this.onCreated,
  });

  @override
  State<Dice3D> createState() => _Dice3DState();
}

class _Dice3DState extends State<Dice3D> {
  late Scene _scene;
  Object? _dice;

  @override
  void didUpdateWidget(Dice3D oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.position != oldWidget.position ||
        widget.rotation != oldWidget.rotation ||
        widget.scale != oldWidget.scale) {
      _applyTransform();
    }
  }

  void _applyTransform() {
    if (_dice != null) {
      _dice!
        ..position.setFrom(widget.position ?? Vector3.zero())
        ..rotation.setFrom(widget.rotation ?? Vector3.zero())
        ..scale.setFrom(widget.scale ?? Vector3.all(1.0))
        ..updateTransform();
      _scene.update();
    }
  }

  void _onSceneCreated(Scene scene) {
    scene.camera.position.z = 5;

    _scene = scene;
    _dice = Object(
      fileName: widget.fileName,
      isAsset: widget.isAsset,
      position: widget.position,
      rotation: widget.rotation,
      scale: widget.scale,
      backfaceCulling: false,
    );
    scene.world.add(_dice!);
    widget.onCreated?.call(_dice!);
  }

  @override
  Widget build(BuildContext context) {
    return Cube(
      onSceneCreated: _onSceneCreated,
      interactive: false,
    );
  }
}
