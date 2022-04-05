import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:swaminarayancounter/Controller/ad_helper.dart';
import 'package:swaminarayancounter/constant.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class ViewLiveDarshan extends StatefulWidget {
  final String youtubeId;
  final String place;
  const ViewLiveDarshan(
      {Key? key, required this.youtubeId, required this.place})
      : super(key: key);

  @override
  _ViewLiveDarshanState createState() => _ViewLiveDarshanState();
}

class _ViewLiveDarshanState extends State<ViewLiveDarshan> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.youtubeId,
      params: const YoutubePlayerParams(
        autoPlay: true,
        showControls: false,
        showFullscreenButton: true,
        desktopMode: false,
        privacyEnhanced: true,
        useHybridComposition: true,
      ),
    );
    _controller.onEnterFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    };
    _controller.onExitFullscreen = () {};

    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          if (kDebugMode) {
            print('Failed to load a banner ad: ${err.message}');
          }
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
  }

  @override
  void dispose() {
    _controller.close();
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const player = YoutubePlayerIFrame();
    return YoutubePlayerControllerProvider(
      // Passing controller to widgets below.
      controller: _controller,
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (kIsWeb && constraints.maxWidth > 800) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(child: player),
                  SizedBox(
                    width: 500,
                    child: SingleChildScrollView(
                      child: Controls(place: widget.place),
                    ),
                  ),
                ],
              );
            }
            return ListView(
              children: [
                Stack(
                  children: const [player],
                ),
                Controls(place: widget.place),
                const SizedBox(
                  height: customHeight * 3,
                ),
                // TODO: Display a banner when ready
                if (_isBannerAdReady)
                  Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: _bannerAd.size.width.toDouble(),
                      height: _bannerAd.size.height.toDouble(),
                      child: AdWidget(ad: _bannerAd),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  // TODO: Add _bannerAd
  late BannerAd _bannerAd;

  // TODO: Add _isBannerAdReady
  bool _isBannerAdReady = false;
}

class Controls extends StatelessWidget {
  final String place;
  const Controls({Key? key, required this.place}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _space,
          MetaDataSection(place: place),
          _space,
        ],
      ),
    );
  }

  Widget get _space => const SizedBox(height: 10);
}

class MetaDataSection extends StatelessWidget {
  final String place;
  const MetaDataSection({Key? key, required this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Text('Title', "🔴 લાઈવ દર્શન"),
        const SizedBox(height: 10),
        _Text('તીર્થ ધામ', place),
        const SizedBox(height: 10),
        const _Text(
          'Playback Quality',
          "HD",
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const _Text(
              'Speed',
              '',
            ),
            YoutubeValueBuilder(
              builder: (context, value) {
                return DropdownButton(
                  value: value.playbackRate,
                  isDense: true,
                  underline: const SizedBox(),
                  items: PlaybackRate.all
                      .map(
                        (rate) => DropdownMenuItem(
                          child: Text(
                            '${rate}x',
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          value: rate,
                        ),
                      )
                      .toList(),
                  onChanged: (double? newValue) {
                    if (newValue != null) {
                      context.ytController.setPlaybackRate(newValue);
                    }
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _Text extends StatelessWidget {
  final String title;
  final String value;

  const _Text(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: '$title : ',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
