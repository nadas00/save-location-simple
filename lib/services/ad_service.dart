import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:save_location/ad_id_data.dart';

class AdService {
  static BannerAd _bannerAd;
  static InterstitialAd _interstitialAd;
  static MobileAdTargetingInfo _targetingInfo = MobileAdTargetingInfo();

  static String getBannerId() {
    if (Platform.isAndroid) {
      return bannerAdIds["android"];
    } else if (Platform.isIOS) {
      return bannerAdIds["ios"];
    }
  }

  static String getInterstitialId() {
    if (Platform.isAndroid) {
      return InterstitialIds["android"];
    } else if (Platform.isIOS) {
      return InterstitialIds["ios"];
    }
  }

  static _getBannerAd() {
    return BannerAd(
      adUnitId: getBannerId(),
      size: AdSize.fullBanner,
      targetingInfo: _targetingInfo,
      listener: (MobileAdEvent bannerEvent) {
        print("Banner : $bannerEvent");
      },
    );
  }

  static loadBannerAd() {
    _bannerAd ??= _getBannerAd();
    _bannerAd
      ..load()
      ..show(anchorOffset: 0, horizontalCenterOffset: 0);
  }

  static _getInterstitialAd() {
    return InterstitialAd(
      adUnitId: getInterstitialId(),
      targetingInfo: _targetingInfo,
      listener: (MobileAdEvent event) async {
        print("Interstitial : $event");
        switch (event) {
          case MobileAdEvent.closed:
            disposeInterstitialAd();
            loadInterstitialAd();
            break;
          default:
            break;
        }
      },
    );
  }

  static loadInterstitialAd() {
    _interstitialAd = _getInterstitialAd();
    _interstitialAd.load();
  }

  static showInterstitialAd() {
    _interstitialAd ??= _getInterstitialAd();
    _interstitialAd?.show(
      anchorOffset: 0.0,
      horizontalCenterOffset: 0.0,
    );
  }

  static disposeInterstitialAd() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }

  static saveWithAd(Function savingOps) async {
    try {
      await _interstitialAd.isLoaded().then((adAvailable) {
        if (adAvailable) {
          AdService.showInterstitialAd();
        } else {
          savingOps();
        }
      });
    } catch (e) {
      print(e);
      savingOps();
    }
  }
}
