import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobService with ChangeNotifier {
  static String? get bannerAdUnitId {
    return 'ca-app-pub-3095044998848311/4364770007';
  }

  static final BannerAdListener bannerAdListener = BannerAdListener(
    onAdLoaded: (ad) => debugPrint('Ad LOaded'),
    onAdFailedToLoad: (ad, error) {
      ad.dispose();
      debugPrint('AD Failed to load ${error}');
    },
    onAdOpened: (ad) => debugPrint('Ad OPned'),
    onAdClosed: (ad) => debugPrint('Ad Closed'),
  );

//  ------------------------NAtive add-------------------------------------//

  static String? get nativeAdUnitId {
    return 'ca-app-pub-3940256099942544/2247696110'; // Example test ID for native ad
  }

  static final NativeAdListener nativeAdListener = NativeAdListener(
    onAdLoaded: (ad) => debugPrint('Native Ad Loaded'),
    onAdFailedToLoad: (ad, error) {
      ad.dispose();
      debugPrint('Native Ad Failed to Load: $error');
    },
    onAdOpened: (ad) => debugPrint('Native Ad Opened'),
    onAdClosed: (ad) => debugPrint('Native Ad Closed'),
  );
}
