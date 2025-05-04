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
  String txt_app_legalese(int year) {
    return '© $year LCD Soft';
  }

  @override
  String txt_app_version(String number, String buildNumber) {
    return 'Version $number-$buildNumber';
  }

  @override
  String get txt_about_1 => 'Roll Dice is a lightweight and easy-to-use app for rolling dice anytime, anywhere. Whether you\'re playing a board game or just need a random number, this app is here to help!';

  @override
  String get txt_about_2 => 'This app is free to use. To support the developer and keep improving the app, a small banner ad is displayed.';

  @override
  String get txt_about_3 => 'Thank you for your support!';
}
