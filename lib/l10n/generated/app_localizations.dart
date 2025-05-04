import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// No description provided for @txt_app_title.
  ///
  /// In en, this message translates to:
  /// **'Simple Roll Dice'**
  String get txt_app_title;

  /// No description provided for @txt_btn_roll.
  ///
  /// In en, this message translates to:
  /// **'Roll Dice'**
  String get txt_btn_roll;

  /// No description provided for @txt_btn_close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get txt_btn_close;

  /// No description provided for @txt_btn_about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get txt_btn_about;

  /// No description provided for @txt_settings_title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get txt_settings_title;

  /// No description provided for @txt_settings_audio.
  ///
  /// In en, this message translates to:
  /// **'Sound effect: {value}'**
  String txt_settings_audio(String value);

  /// No description provided for @txt_settings_number_dices.
  ///
  /// In en, this message translates to:
  /// **'Number dices: {value}'**
  String txt_settings_number_dices(int value);

  /// No description provided for @txt_settings_on.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get txt_settings_on;

  /// No description provided for @txt_settings_off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get txt_settings_off;

  /// No description provided for @txt_app_legalese.
  ///
  /// In en, this message translates to:
  /// **'© {year} LCD Soft'**
  String txt_app_legalese(int year);

  /// No description provided for @txt_app_version.
  ///
  /// In en, this message translates to:
  /// **'Version {number}-{buildNumber}'**
  String txt_app_version(String number, String buildNumber);

  /// No description provided for @txt_about_1.
  ///
  /// In en, this message translates to:
  /// **'Roll Dice is a lightweight and easy-to-use app for rolling dice anytime, anywhere. Whether you\'re playing a board game or just need a random number, this app is here to help!'**
  String get txt_about_1;

  /// No description provided for @txt_about_2.
  ///
  /// In en, this message translates to:
  /// **'This app is free to use. To support the developer and keep improving the app, a small banner ad is displayed. Thank you for your support!'**
  String get txt_about_2;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'vi': return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
