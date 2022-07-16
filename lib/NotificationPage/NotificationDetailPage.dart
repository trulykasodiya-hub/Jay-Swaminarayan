

import 'package:cached_network_image/cached_network_image.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:swaminarayancounter/Utility/env.dart';
import 'package:swaminarayancounter/skeletons/skeletons_wallpaper.dart';

class NotificationDetailPage extends StatefulWidget {
  final String title;
  final String body;
  final String image;
  const NotificationDetailPage({Key? key,required this.title,required this.body,required this.image}) : super(key: key);

  @override
  State<NotificationDetailPage> createState() => _NotificationDetailPageState();
}

class _NotificationDetailPageState extends State<NotificationDetailPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FacebookAudienceNetwork.init(
        iOSAdvertiserTrackingEnabled: true //default false
    );
    _showNativeAd();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text("જય સ્વામિનારાયણ"),
        actions: [IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.home)),],
      ),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            Text(widget.title,style:const TextStyle(fontSize: 23,fontWeight: FontWeight.bold),textAlign: TextAlign.justify,),
            const SizedBox(height: 18),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: CachedNetworkImage(
                imageUrl: widget.image,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                    child: skeletonsSuvichar()
                ),
                errorWidget: (context, url, uri) => const Center(
                  child: Icon(
                    Icons.error_outline_rounded,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(widget.body,style:const TextStyle(fontSize: 18,fontWeight: FontWeight.normal),textAlign: TextAlign.justify),
            const SizedBox(height: 18),
            Flexible(
              child: Align(
                alignment: const Alignment(0, 1.0),
                child: _currentAd,
              ),
              fit: FlexFit.tight,
              flex: 3,
            )
          ],
        ),
      )),
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
