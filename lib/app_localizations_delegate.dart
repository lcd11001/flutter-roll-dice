import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// https://stackoverflow.com/questions/50067455/string-xml-file-in-flutter
class AppLocalizations {
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  String translate(String key) {
    if (_localizedStrings.containsKey(key) == false) {
      debugPrint('AppLocalizations: missing key: $key');
      // wrong text key
      return '[$key]';
    }
    // localize text
    return _localizedStrings[key];
  }
}

late Map<String, dynamic> _localizedStrings;

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    final supported = ['en', 'vi'].contains(locale.languageCode);
    debugPrint(
        'AppLocalizations ${locale.languageCode} isSupported: $supported');
    return supported;
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    debugPrint('AppLocalizations load: ${locale.languageCode}');

    try {
      String string = await rootBundle
          .loadString('assets/strings/${locale.languageCode}.json');
      _localizedStrings = json.decode(string);
    } catch (e) {
      debugPrint('AppLocalizations error: $e');
      debugPrint('AppLocalizations load EN as default language');
      String defaultString =
          await rootBundle.loadString('assets/strings/en.json');
      _localizedStrings = json.decode(defaultString);
    }

    return SynchronousFuture<AppLocalizations>(AppLocalizations());
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
