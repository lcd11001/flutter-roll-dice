import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:simple_roll_dice/app_version.dart';

import 'package:simple_roll_dice/gradient_container.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      // auto detect the device locale
      //locale: const Locale('vi', 'VN'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.transparent,
          constraints: BoxConstraints.expand(height: 40),
        ),
      ),
      home: const Scaffold(
        //body: GradientContainer(colors: [Colors.blue, Colors.green]),
        body: GradientContainer.purple(),
        bottomSheet: AppVersion(builder: builderAppVersion),
      ),
    ),
  );
}

Widget builderAppVersion(BuildContext context, PackageInfo packageInfo) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.all(10),
    //color: Colors.red,
    child: Align(
      alignment: Alignment.centerRight,
      child: Text(
        'Version: ${packageInfo.version}-${packageInfo.buildNumber}',
        style: const TextStyle(
          fontSize: 15,
          color: Colors.white,
        ),
      ),
    ),
  );
}
