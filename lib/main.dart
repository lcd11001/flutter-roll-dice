import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_roll_dice/app.dart';
import 'package:simple_roll_dice/providers/provider_settings.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  MobileAds.instance.initialize().then((InitializationStatus initStatus) {
    debugPrint("Initialization MobileAds complete:");
    // You can optionally print the status of each adapter
    initStatus.adapterStatuses.forEach((key, value) {
      debugPrint(
        'Adapter status for $key: '
        'State=${value.state}, Description=${value.description}',
      );
    });
  });
  RequestConfiguration requestConfiguration = RequestConfiguration(
    testDeviceIds: ['90403bfa-19da-4bab-b9d2-a0ff5a386c80'],
  );
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);

  GoogleFonts.config.allowRuntimeFetching = false;

  try {
    LicenseRegistry.addLicense(() async* {
      final licensePacifico = await rootBundle.loadString(
        'assets/google_fonts/Pacifico/OFL.txt',
      );
      debugPrint("Pacifico: $licensePacifico");
      yield LicenseEntryWithLineBreaks([
        'google_fonts/Pacifico',
      ], licensePacifico);

      final licenseBlackOpsOne = await rootBundle.loadString(
        'assets/google_fonts/Black_Ops_One/OFL.txt',
      );
      debugPrint("BlackOpsOne: $licenseBlackOpsOne");
      yield LicenseEntryWithLineBreaks([
        'google_fonts/Black_Ops_One',
      ], licenseBlackOpsOne);

      final licenseYesevaOne = await rootBundle.loadString(
        'assets/google_fonts/Yeseva_One/OFL.txt',
      );
      debugPrint("YesevaOne: $licenseYesevaOne");
      yield LicenseEntryWithLineBreaks([
        'google_fonts/Yeseva_One',
      ], licenseYesevaOne);
    });
  } catch (e) {
    debugPrint("Error: $e");
  }

  final container = ProviderContainer();
  await container.read(settingsProvider.notifier).loadSettings();

  runApp(UncontrolledProviderScope(container: container, child: const App()));
}
