import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:simple_roll_dice/providers/provider_settings.dart';

import 'package:simple_roll_dice/l10n/generated/app_localizations.dart';

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
              color: Colors.black.withAlpha(128),
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
                  loc.txt_settings_title,
                  style: GoogleFonts.getFont("Yeseva One").copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSwitch(
                  title: loc.txt_settings_audio(settings.allowAudio
                      ? loc.txt_settings_on
                      : loc.txt_settings_off),
                  value: settings.allowAudio,
                  onChanged: (value) => settingsNotifier.toggleAllowAudio(),
                ),
                const SizedBox(height: 16),
                _buildSlider(
                  title: loc.txt_settings_number_dices(settings.numberDices),
                  minValue: settings.minDices,
                  maxValue: settings.maxDices,
                  value: settings.numberDices,
                  divisions: settings.maxDices - settings.minDices,
                  onChanged: (value) => settingsNotifier.setNumberDices(value),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => _showAboutDialog(context),
                      child: Text(loc.txt_btn_about),
                    ),
                    TextButton(
                      onPressed: () => onClose(settingsNotifier),
                      child: Text(loc.txt_btn_close),
                    ),
                  ],
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
        Text(
          title,
          style: GoogleFonts.getFont("Yeseva One").copyWith(
            fontSize: 18,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSlider({
    required String title,
    required int value,
    required ValueChanged<int> onChanged,
    int minValue = 0,
    int maxValue = 10,
    int divisions = 3,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.getFont("Yeseva One").copyWith(
            fontSize: 18,
          ),
        ),
        Slider(
          value: value.toDouble(),
          min: minValue.toDouble(),
          max: maxValue.toDouble(),
          divisions: divisions,
          label: value.toString(),
          onChanged: (value) => onChanged(value.toInt()),
        ),
      ],
    );
  }

  void onClose(ProviderSettingsNotifier settingsNotifier) {
    debugPrint("close");
    settingsNotifier.toggleShowSettings();
  }

  Future<void> _showAboutDialog(BuildContext context) async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    if (!context.mounted) return;

    final loc = AppLocalizations.of(context)!;
    showAboutDialog(
      context: context,
      applicationName: packageInfo.appName,
      applicationVersion:
          loc.txt_app_version(packageInfo.version, packageInfo.buildNumber),
      applicationIcon: Image.asset(
        'assets/icons/icon_1024x1024.png',
        width: 48,
        height: 48,
      ),
      applicationLegalese: loc.txt_app_legalese,
      barrierColor: Colors.black.withAlpha(128),
      children: [
        const SizedBox(height: 16),
        Text(
          loc.txt_about_1,
          style: GoogleFonts.getFont("Yeseva One").copyWith(
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          loc.txt_about_2,
          style: GoogleFonts.getFont("Yeseva One").copyWith(
            fontSize: 16,
          ),
        ),
      ]

    );
  }
}
