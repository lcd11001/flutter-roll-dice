import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResultText extends StatefulWidget {
  final int number;
  final int duration;

  const ResultText({
    super.key,
    required this.number,
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

  final AudioPlayer _audioPlayer = AudioPlayer();
  final soundUrl =
      'https://www.sorobanexam.org/tools/tts?number={number}&lang={language}';

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
  void didChangeDependencies() {
    super.didChangeDependencies();

    final language = AppLocalizations.of(context)!.localeName;
    final url = soundUrl
        .replaceFirst('{number}', widget.number.toString())
        .replaceFirst('{language}', language);

    _playSound(url);
  }

  Future<void> _playSound(String url) async {
    try {
      debugPrint('Playing sound: $url');
      await _audioPlayer.play(UrlSource(url), mode: PlayerMode.mediaPlayer);
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (ctx, child) {
        return Text(
          widget.number.toString(),
          style: TextStyle(
            fontSize: _animation.value * 200,
            color: Colors.white,
          ),
        );
      },
    );
  }
}
