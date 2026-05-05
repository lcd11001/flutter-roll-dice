import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:simple_roll_dice/app_version.dart';
import 'package:simple_roll_dice/gradient_background.dart';
import 'package:simple_roll_dice/roll_dice_app.dart';

import 'package:simple_roll_dice/l10n/generated/app_localizations.dart';
import 'package:simple_roll_dice/widgets/settings_icon_button.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // auto detect the device locale
      // locale: const Locale('vi', 'VN'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.transparent,
          constraints: BoxConstraints.expand(height: 40),
        ),
      ),
      home: GradientBackground.purple(
        child: Builder(
          builder: (ctx) {
            final safeAreaPadding = MediaQuery.of(ctx).viewPadding;
            return SafeArea(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: RollDiceApp(safeAreaPadding: safeAreaPadding),
                bottomSheet: AppVersion(builder: builderAppVersion),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget builderAppVersion(BuildContext context, PackageInfo packageInfo) {
    final loc = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 10, right: 10),
      // color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SettingsIconButton(),
          Text(
            loc.txt_app_version(packageInfo.version),
            style: const TextStyle(fontSize: 15, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
