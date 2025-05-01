// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get txt_app_title => 'Đỗ Xí Ngầu';

  @override
  String get txt_btn_roll => 'Lắc';

  @override
  String get txt_btn_close => 'Đóng';

  @override
  String get txt_btn_about => 'Thông Tin';

  @override
  String get txt_settings_title => 'Cài Đặt';

  @override
  String txt_settings_audio(String value) {
    return 'Âm thanh: $value';
  }

  @override
  String txt_settings_number_dices(int value) {
    return 'Số xí ngầu: $value';
  }

  @override
  String get txt_settings_on => 'Bật';

  @override
  String get txt_settings_off => 'Tắt';

  @override
  String get txt_app_legalese => '© 2024 LCD Soft';

  @override
  String txt_app_version(String number, String buildNumber) {
    return 'Version $number-$buildNumber';
  }
}
