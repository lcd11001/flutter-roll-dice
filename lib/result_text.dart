import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_roll_dice/providers/provider_settings.dart';

class ResultText extends ConsumerStatefulWidget {
  final int number;
  final int milisecondsDuration;
  final void Function(PlayerState)? onCompleted;

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

  final AudioPlayer _audioPlayer = AudioPlayer();

  final soundUrl =
      'https://www.sorobanexam.org/tools/tts?number={number}&lang={language}';

  @override
  void initState() {
    super.initState();

    _audioPlayer.onPlayerStateChanged.listen((event) {
      debugPrint('Player state changed: $event');
      _handleCompletion(event);
    });

    googleFontsPending = GoogleFonts.pendingFonts([
      GoogleFonts.blackOpsOne(),
    ]);

    _controller = AnimationController(
      duration: Duration(milliseconds: widget.milisecondsDuration),
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
    final settings = ref.watch(settingsProvider);
    if (!settings.allowAudio) {
      // If sound is not allowed, we'll wait for the animation to complete
      // before raising the completion event
      _controller.addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            _handleCompletion(PlayerState.completed);
          }
        },
      );
      return;
    }

    try {
      debugPrint('Playing sound: $url');
      await _audioPlayer.play(UrlSource(url), mode: PlayerMode.mediaPlayer);
    } catch (e) {
      debugPrint('Error playing sound: $e');
      // If there's an error playing the sound, we'll still complete the animation
      _handleCompletion(PlayerState.completed);
    }
  }

  void _handleCompletion(PlayerState state) {
    if (state == PlayerState.completed) {
      widget.onCompleted?.call(state);
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
              style: GoogleFonts.getFont("Black Ops One").copyWith(
                fontSize: _animation.value * 200,
                color: Colors.white,
              ),
            );
          },
        );
      },
    );
  }
}
