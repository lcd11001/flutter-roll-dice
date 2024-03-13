import 'package:flutter/material.dart';

import 'package:simple_roll_dice/gradient_container.dart';

import 'package:simple_roll_dice/app_localizations_delegate.dart';

void main() {
  runApp(
    const MaterialApp(
      locale: Locale('en'),
      localizationsDelegates: [AppLocalizationsDelegate()],
      supportedLocales: [Locale('en'), Locale('vi')],
      home: Scaffold(
        //body: GradientContainer(colors: [Colors.blue, Colors.green]),
        body: GradientContainer.purple(),
      ),
    ),
  );
}
