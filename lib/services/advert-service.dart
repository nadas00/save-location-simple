import 'dart:io';
import 'package:firebase_admob/firebase_admob.dart';

class AdvertService {
  static final AdvertService _instance = AdvertService._internal();

  factory AdvertService() => _instance;
  MobileAdTargetingInfo _targetingInfo;
  final String _bannerAd = Platform.isAndroid
      ? 'ca-app-pub-1965278103872493/6286344231'
      : 'ca-app-pub-1965278103872493/2907487955';
  final String _intersitialAd = Platform.isAndroid
      ? 'ca-app-pub-1965278103872493/8821325460'
      : 'ca-app-pub-1965278103872493/7189691358';
  final String _rewardedAd = Platform.isAndroid
      ? 'ca-app-pub-1965278103872493/9883943930'
      : 'ca-app-pub-1965278103872493/6752182438';

  AdvertService._internal() {
    _targetingInfo = MobileAdTargetingInfo();
  }

  showBanner() {
    BannerAd banner = BannerAd(
        adUnitId: _bannerAd,
        size: AdSize.banner,
        targetingInfo: _targetingInfo);

    banner
      ..load()
      ..show();

    banner.dispose();
  }

  showIntersitial() {
    InterstitialAd interstitialAd = InterstitialAd(
        adUnitId: _intersitialAd, targetingInfo: _targetingInfo);

    interstitialAd
      ..load()
      ..show();

    interstitialAd.dispose();
  }
  
  bool isRewardedAdReady;

  void loadRewardedAd() {
    RewardedVideoAd.instance.load(
      targetingInfo: _targetingInfo,
      adUnitId: _rewardedAd,
    );
  }

  void showReardedAd(){
    RewardedVideoAd.instance.show();
  }
  
  void addRewardListener(){
    RewardedVideoAd.instance.listener = onRewardedAdEvent;
  }

  void onRewardedAdEvent(RewardedVideoAdEvent event,
      {String rewardType, int rewardAmount}) {
    switch (event) {
      case RewardedVideoAdEvent.loaded:
        isRewardedAdReady = true;
        break;
        
      case RewardedVideoAdEvent.closed:
        isRewardedAdReady = false;
        loadRewardedAd();
        break;
        
      case RewardedVideoAdEvent.failedToLoad:
        isRewardedAdReady = false;
        print('Failed to load a rewarded ad');
        break;
        
      case RewardedVideoAdEvent.rewarded:
        //TODO:ODUL AYARLA
        print('odul verildi');
        break;
        
      default:
      // do nothing
    }
  }

  void dispose() {
    RewardedVideoAd.instance.listener = null;
  }
}
