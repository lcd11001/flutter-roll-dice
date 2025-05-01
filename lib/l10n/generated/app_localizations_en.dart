// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get txt_app_title => 'Simple Roll Dice';

  @override
  String get txt_btn_roll => 'Roll Dice';

  @override
  String get txt_btn_close => 'Close';

  @override
  String get txt_btn_about => 'About';

  @override
  String get txt_settings_title => 'Settings';

  @override
  String txt_settings_audio(String value) {
    return 'Sound effect: $value';
  }

  @override
  String txt_settings_number_dices(int value) {
    return 'Number dices: $value';
  }

  @override
  String get txt_settings_on => 'On';

  @override
  String get txt_settings_off => 'Off';

  @override
  String get txt_app_legalese => '© 2024 LCD Soft';

  @override
  String txt_app_version(String number, String buildNumber) {
    return 'Version $number-$buildNumber';
  }
}
