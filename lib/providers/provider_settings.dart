import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderSettings {
  final int minDices = 1;
  final int maxDices = 3;
  final int numberDices;
  final bool allowAudio;
  final bool showSettings;

  ProviderSettings._({
    required this.numberDices,
    required this.allowAudio,
    required this.showSettings,
  });

  ProviderSettings copyWith({
    int? numberDices,
    bool? allowAudio,
    bool? showSettings,
  }) {
    return ProviderSettings._(
      numberDices: (numberDices ?? this.numberDices).clamp(minDices, maxDices),
      allowAudio: allowAudio ?? this.allowAudio,
      showSettings: showSettings ?? this.showSettings,
    );
  }
}

class ProviderSettingsNotifier extends StateNotifier<ProviderSettings> {
  ProviderSettingsNotifier()
      : super(
          ProviderSettings._(
            numberDices: 3,
            allowAudio: true,
            showSettings: false,
          ),
        );

  void toggleShowSettings() {
    state = state.copyWith(showSettings: !state.showSettings);
    _saveSettings();
  }

  void toggleAllowAudio() {
    state = state.copyWith(allowAudio: !state.allowAudio);
    _saveSettings();
  }

  void setNumberDices(int numberDices) {
    state = state.copyWith(
      numberDices: numberDices.clamp(
        state.minDices,
        state.maxDices,
      ),
    );
    _saveSettings();
  }

  Future<void> loadSettings() async {
    debugPrint('Loading settings');
    final prefs = await SharedPreferences.getInstance();
    state = ProviderSettings._(
      allowAudio: prefs.getBool('allowAudio') ?? true,
      numberDices: prefs.getInt('numberDices') ?? 3,
      showSettings: false,
    );
  }

  Future<void> _saveSettings() async {
    debugPrint('Saving settings');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('allowAudio', state.allowAudio);
    await prefs.setInt('numberDices', state.numberDices);
  }
}

final settingsProvider =
    StateNotifierProvider<ProviderSettingsNotifier, ProviderSettings>((ref) {
  return ProviderSettingsNotifier();
});
