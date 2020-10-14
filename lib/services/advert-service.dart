import 'dart:io';
import 'package:firebase_admob/firebase_admob.dart';

class AdvertService {
  static final AdvertService _instance = AdvertService._internal();
  factory AdvertService() => _instance;
  MobileAdTargetingInfo _targetingInfo;
  final String _bannerAd = Platform.isAndroid ? 'ca-app-pub-1965278103872493/6286344231' : 'ca-app-pub-1965278103872493/8505313468';
  final String _intersitialAd = Platform.isAndroid ? 'ca-app-pub-1965278103872493/8821325460' : 'ca-app-pub-1965278103872493/5168364375';

  AdvertService._internal() {
    _targetingInfo = MobileAdTargetingInfo();
  }

  showBanner(){
    BannerAd banner = BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.banner,
      targetingInfo: _targetingInfo
    );

    banner
      ..load()
      ..show();

    banner.dispose();
  }

  showIntersitial(){
    InterstitialAd interstitialAd = InterstitialAd(
      adUnitId: _intersitialAd, targetingInfo: _targetingInfo);

    interstitialAd
      ..load()
      ..show();

    interstitialAd.dispose();
  }

}
