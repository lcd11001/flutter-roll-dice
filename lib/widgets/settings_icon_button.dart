import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_roll_dice/providers/provider_settings.dart';

class SettingsIconButton extends ConsumerWidget {
  const SettingsIconButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providerSettingsNotifier =
        ref.read(providerSettingsProvider.notifier);

    return IconButton(
      padding: EdgeInsets.zero, // Remove default padding
      alignment: Alignment.center,
      icon: const Icon(
        Icons.settings,
        color: Colors.white,
        size: 40,
      ),
      onPressed: () {
        debugPrint("settings");
        providerSettingsNotifier.toggleShowSettings();
      },
    );
  }
}
