import 'package:admob_demo/ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewaredPage extends StatefulWidget {
  const RewaredPage({Key? key}) : super(key: key);

  @override
  State<RewaredPage> createState() => _RewaredPageState();
}

class _RewaredPageState extends State<RewaredPage> {
  late RewardedAd _rewardedAd;
  bool _isRewardedAdReady = false;

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          this._rewardedAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                _isRewardedAdReady = false;
              });
              _loadRewardedAd();
            },
          );

          setState(() {
            _isRewardedAdReady = true;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load a rewarded ad: ${err.message}');
          setState(() {
            _isRewardedAdReady = false;
          });
        },
      ),
    );
  }

  Widget? _buildFloatingActionButton() {
    var QuizManager;
    return (!QuizManager.instance.isHintUsed && _isRewardedAdReady)
        ? FloatingActionButton.extended(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Need a hint?'),
                    content: Text('Watch an Ad to get a hint!'),
                    actions: [
                      TextButton(
                        child: Text('cancel'.toUpperCase()),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: Text('ok'.toUpperCase()),
                        onPressed: () {
                          Navigator.pop(context);
                          _rewardedAd.show(
                              onUserEarnedReward:
                                  (AdWithoutView ad, RewardItem reward) {});
                        },
                      ),
                    ],
                  );
                },
              );
            },
            label: Text('Hint'),
            icon: Icon(Icons.card_giftcard),
          )
        : null;
  }

  @override
  void dispose() {
    _rewardedAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AD MOBE 2"),
        centerTitle: true,
      ),
      body: Center(
          child: ElevatedButton(
              onPressed: () {
                _buildFloatingActionButton();
              },
              child: const Text("NEXT"))),
    );
  }
}
