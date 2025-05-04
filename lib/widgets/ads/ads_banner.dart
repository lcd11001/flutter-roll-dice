import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:simple_roll_dice/widgets/ads/ads_helper.dart';

class AdsBanner extends StatefulWidget {
  const AdsBanner({super.key});

  @override
  State<AdsBanner> createState() => _AdsBannerState();
}

class _AdsBannerState extends State<AdsBanner> {
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdsHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('BannerAd failed to load: $error');
          _isBannerAdReady = false;
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    const double padding = 10.0;
    if (_isBannerAdReady) {
      return Container(
        padding: const EdgeInsets.only(top: padding, bottom: padding),
        width: double.infinity,
        height: _bannerAd!.size.height.toDouble() + padding * 2,
        alignment: Alignment.center,
        child: AdWidget(ad: _bannerAd!),
      );
    }

    return SizedBox();
  }
}
