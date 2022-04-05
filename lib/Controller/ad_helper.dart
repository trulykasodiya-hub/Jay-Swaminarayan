import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9521533071695014/4737500360';
    } else if (Platform.isIOS) {
      return '';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-9521533071695014/3217369282";
    } else if (Platform.isIOS) {
      return "";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
