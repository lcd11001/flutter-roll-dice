import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProviderSettings {
  int minDices = 1;
  int maxDices = 3;
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
  }

  void toggleAllowAudio() {
    state = state.copyWith(allowAudio: !state.allowAudio);
  }

  void setNumberDices(int numberDices) {
    state = state.copyWith(
        numberDices: numberDices.clamp(state.minDices, state.maxDices));
  }
}

final settingsProvider =
    StateNotifierProvider<ProviderSettingsNotifier, ProviderSettings>((ref) {
  return ProviderSettingsNotifier();
});
