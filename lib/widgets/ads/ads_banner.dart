import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:simple_roll_dice/widgets/ads/ads_helper.dart';

class AdsBanner extends StatefulWidget {
  final void Function(bool isAdReady)? onLoadStatusChanged;
  final double padding;
  const AdsBanner({super.key, this.padding = 10.0, this.onLoadStatusChanged});

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

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void _loadBannerAd() {
    _createBannerAd(AdsHelper.bannerAdUnitId);
  }

  void _createBannerAd(String adUnitId) {
    // Dispose previous ad if any before creating new one
    _bannerAd?.dispose();

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('BannerAd ${ad.adUnitId} loaded:  ${ad.hashCode}');
          if (mounted) {
            setState(() {
              _isBannerAdReady = true;
            });
            widget.onLoadStatusChanged?.call(true);
          }
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('BannerAd ${ad.adUnitId} failed to load: $error');
          if (mounted) {
            setState(() {
              _isBannerAdReady = false;
            });
            widget.onLoadStatusChanged?.call(false);
          }
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    if (_isBannerAdReady) {
      return Container(
        padding: EdgeInsets.only(top: widget.padding, bottom: widget.padding),
        width: double.infinity,
        height: _bannerAd!.size.height.toDouble() + widget.padding * 2,
        alignment: Alignment.center,
        child: AdWidget(ad: _bannerAd!),
      );
    }

    return SizedBox();
  }
}
