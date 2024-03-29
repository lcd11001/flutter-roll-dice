import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:simple_roll_dice/app_version.dart';

import 'package:simple_roll_dice/gradient_container.dart';

import 'package:simple_roll_dice/app_localizations_delegate.dart';

void main() {
  runApp(
    MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [AppLocalizationsDelegate()],
      supportedLocales: const [Locale('en'), Locale('vi')],
      theme: ThemeData(
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.transparent,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Version: ${packageInfo.version}-${packageInfo.buildNumber}',
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        ],
      ));
}
