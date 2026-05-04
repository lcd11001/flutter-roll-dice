import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';

class ResultText extends ConsumerStatefulWidget {
  final int number;
  final int milisecondsDuration;
  final void Function()? onCompleted;

  const ResultText({
    super.key,
    required this.number,
    this.milisecondsDuration = 500,
    this.onCompleted,
  });

  @override
  ConsumerState<ResultText> createState() => _ResultTextState();
}

class _ResultTextState extends ConsumerState<ResultText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _curvedAnimation;
  late final Animation<double> _animation;

  late final Future googleFontsPending;

  @override
  void initState() {
    super.initState();

    googleFontsPending = GoogleFonts.pendingFonts([GoogleFonts.blackOpsOne()]);

    _controller = AnimationController(
      duration: Duration(milliseconds: widget.milisecondsDuration),
      vsync: this,
    );

    _curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_curvedAnimation);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onCompleted?.call();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: googleFontsPending,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox();
        }

        return AnimatedBuilder(
          animation: _animation,
          builder: (ctx, child) {
            return Text(
              widget.number.toString(),
              style: GoogleFonts.getFont(
                "Black Ops One",
              ).copyWith(fontSize: _animation.value * 200, color: Colors.white),
            );
          },
        );
      },
    );
  }
}
