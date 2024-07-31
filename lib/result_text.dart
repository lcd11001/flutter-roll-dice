import 'package:flutter/material.dart';

class ResultText extends StatefulWidget {
  final String text;
  final int duration;

  const ResultText({
    super.key,
    required this.text,
    this.duration = 500,
  });

  @override
  State<ResultText> createState() => _ResultTextState();
}

class _ResultTextState extends State<ResultText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _curvedAnimation;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: widget.duration),
      vsync: this,
    );

    _curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_curvedAnimation);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (ctx, child) {
        return Text(
          widget.text,
          style: TextStyle(
            fontSize: _animation.value * 200,
            color: Colors.white,
          ),
        );
      },
    );
  }
}
