import 'dart:io';

class AdsHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7397667053558913/4906000838';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-0000000000000000/0000000000';
    } else {
      throw UnsupportedError(
        'Unsupported platform: ${Platform.operatingSystem}',
      );
    }
  }
}
