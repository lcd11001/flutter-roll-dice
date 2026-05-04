import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_roll_dice/l10n/generated/app_localizations.dart';
import 'package:simple_roll_dice/providers/provider_settings.dart';

class VoiceWidget extends ConsumerStatefulWidget {
  final int number;
  final void Function(PlayerState)? onCompleted;

  const VoiceWidget({super.key, required this.number, this.onCompleted});

  @override
  ConsumerState<VoiceWidget> createState() => _VoiceWidgetState();
}

class _VoiceWidgetState extends ConsumerState<VoiceWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final soundUrl =
      'https://www.sorobanexam.org/tools/tts?number={number}&lang={language}';

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.completed) {
        widget.onCompleted?.call(event);
      }
    });
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
      widget.onCompleted?.call(PlayerState.completed);
      return;
    }

    try {
      debugPrint('Playing voice sound: $url');
      await _audioPlayer.play(UrlSource(url), mode: PlayerMode.mediaPlayer);
    } catch (e) {
      debugPrint('Error playing voice sound: $e');
      widget.onCompleted?.call(PlayerState.completed);
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
