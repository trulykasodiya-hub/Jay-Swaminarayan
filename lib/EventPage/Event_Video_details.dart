

import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:swaminarayancounter/NotificationPage/NotificationPage.dart';
import 'package:swaminarayancounter/Utility/env.dart';
import 'package:swaminarayancounter/app_drawer.dart';
import 'package:swaminarayancounter/constant.dart';

class EventVideoDetails extends StatefulWidget {
  final dynamic data;
  const EventVideoDetails({Key? key,required this.data}) : super(key: key);

  @override
  State<EventVideoDetails> createState() => _EventVideoDetailsState();
}

class _EventVideoDetailsState extends State<EventVideoDetails> {
  late BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    BetterPlayerConfiguration betterPlayerConfiguration =
   const BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
      handleLifecycle: true,
       autoPlay:true,
    );
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _setupDataSource();

    FacebookAudienceNetwork.init(
        iOSAdvertiserTrackingEnabled: true //default false
    );
    _showNativeAd();

    super.initState();
  }

  void _setupDataSource() async {
    // String imageUrl = await Utils.getFileUrl(Constants.logo);
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(

      BetterPlayerDataSourceType.network,
      widget.data['video_url'],
      liveStream: widget.data['isLive'] == "1" ? true : false,
      notificationConfiguration: BetterPlayerNotificationConfiguration(
        showNotification: true,
        title: widget.data['event_name'],
        author: headerTitle,
        imageUrl: widget.data['url'],
      ),
    );
    _betterPlayerController.setupDataSource(dataSource);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(headerTitle),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              icon: const Icon(Icons.home)),
          IconButton(onPressed: () async {
            final bytes = await rootBundle.load('assets/images/banner.png');
            final list = bytes.buffer.asUint8List();

            final tempDir = await getTemporaryDirectory();
            final file = await File('${tempDir.path}/jaySwaminarayan.jpg').create();
            file.writeAsBytesSync(list);
            Share.shareFiles([file.path],
              text: shareText,
            );
          }, icon: const Icon(Icons.share)),

        ],
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: BetterPlayer(controller: _betterPlayerController),
            ),
            Expanded(child: ListView(
              children: [
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: widget.data['isLive'] == "1" ? Text("🔴  "+widget.data['event_name'],style: const TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold)) : Text(widget.data['event_name'],style: const TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 25),
                Flexible(
                  child: Align(
                    alignment: const Alignment(0, 1.0),
                    child: _currentAd,
                  ),
                  fit: FlexFit.tight,
                  flex: 3,
                )
              ],
            )),

          ],
        ),
      ),
    );
  }

  Widget _currentAd = const SizedBox(
    width: 0.0,
    height: 0.0,
  );

  _showNativeAd() {
    setState(() {
      _currentAd = _nativeAd();
    });
  }

  Widget _nativeAd() {
    return FacebookNativeAd(
      placementId: swaminarayanNativeAdsId,
      adType: NativeAdType.NATIVE_AD_VERTICAL,
      width: double.infinity,
      height: 300,
      backgroundColor: Colors.deepOrange,
      titleColor: Colors.white,
      descriptionColor: Colors.white,
      buttonColor: Colors.deepPurple,
      buttonTitleColor: Colors.white,
      buttonBorderColor: Colors.white,
      listener: (result, value) {
        print("Native Ad: $result --> $value");
      },
      keepExpandedWhileLoading: true,
      expandAnimationDuraion: 1000,
    );
  }
}
