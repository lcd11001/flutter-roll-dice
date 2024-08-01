import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_roll_dice/providers/provider_settings.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPopup extends ConsumerWidget {
  const SettingsPopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final loc = AppLocalizations.of(context)!;

    return Stack(
      children: [
        // Modal barrier
        Positioned.fill(
          child: GestureDetector(
            //onTap: () => onClose(settingsNotifier),
            onTap: () => debugPrint("onTap back ground dialog"),
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        ),
        // Dialog
        Dialog(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "loc.settings_title",
                  style: GoogleFonts.getFont("Yeseva One").copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSwitch(
                  title: "loc.settings_sound",
                  value: settings.allowAudio,
                  onChanged: (value) => settingsNotifier.toggleAllowAudio(),
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => onClose(settingsNotifier),
                    child: Text("loc.btn_close"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitch({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  void onClose(ProviderSettingsNotifier settingsNotifier) {
    debugPrint("close");
    settingsNotifier.toggleShowSettings();
  }
}
