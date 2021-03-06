import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:dio/dio.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import 'package:swaminarayancounter/Utility/api_url.dart';
import 'package:swaminarayancounter/Utility/env.dart';
import 'package:swaminarayancounter/Utility/shared_preferences.dart';
import 'package:swaminarayancounter/main.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class SwaminarayanStatus extends StatefulWidget {
  const SwaminarayanStatus({Key? key}) : super(key: key);
  @override
  State<SwaminarayanStatus> createState() => _SwaminarayanStatusState();
}

class _SwaminarayanStatusState extends State<SwaminarayanStatus> {

  List statusUrl = [];
  void fetchUrl() async {
    try {
      var response = await http.get(Uri.parse(AppUrl.swaminarayanStatus),headers: {
      "Accept": "application/json",
      "Access-Control_Allow_Origin": "*"
      });
      setState(() {
        List newData = [];
       List data = jsonDecode(response.body);
       String? lastId = prefs.getString(swaminarayanLastIdKey);
       if(lastId == null) {
         statusUrl = data;
       }else{
         for(int i = 0; i  < data.length; i++) {
           if(int.parse(data[i]['id']) >= int.parse(lastId)){
             newData.add(data[i]);
           }
         }

         for(int i = 0; i  < data.length; i++) {
           if(int.parse(data[i]['id']) < int.parse(lastId)){
             newData.add(data[i]);
           }
         }
         statusUrl = newData;
       }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUrl();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true, body: statusUrl.isNotEmpty ? SwaminarayanStatusBody(statusUrl: statusUrl) : const Center(child:  CircularProgressIndicator()));
  }
}

class SwaminarayanStatusBody extends StatefulWidget {
  final Controller? testingController;
  final List statusUrl;
  const SwaminarayanStatusBody({
    Key? key,
    required this.statusUrl,
    this.testingController,
  }) : super(key: key);

  @override
  _SwaminarayanStatusBodyState createState() => _SwaminarayanStatusBodyState();
}

class _SwaminarayanStatusBodyState extends State<SwaminarayanStatusBody>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  var adsCount = 0;
  @override
  initState() {
    _tabController =
        TabController(length: widget.statusUrl.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RotatedBox(
        quarterTurns: 1,
        child: TabBarView(
          controller: _tabController,
          children: List.generate(
            widget.statusUrl.length,
            (index) {
              return VideoPlayerItem(url: widget.statusUrl[index]['url'],statusUrl: widget.statusUrl,id: widget.statusUrl[index]['id'],index: index);
            },
          ),
        ),
      ),
    );
  }
}

class VideoPlayerItem extends StatefulWidget {
  final String id;
  final String url;
  final List statusUrl;
  final int index;
  const VideoPlayerItem({Key? key, required this.url, required this.statusUrl,required this.id,required this.index}) : super(key: key);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  VideoPlayerController? _videoController;
  bool isShowPlaying = false;
  bool _isInterstitialAdLoaded = false;
  Dio dio = Dio();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FacebookAudienceNetwork.init(
        iOSAdvertiserTrackingEnabled: true //default false
    );

    _videoController = VideoPlayerController.network(widget.url)
      ..initialize().then((value) {
        if(widget.index != 5) {
          _videoController!.play();
        }
        UserPreferences().saveSwaminarayanLastId(widget.id);
        setState(() {
          isShowPlaying = false;
        });
      });

    if(widget.index == 5) {
      _loadInterstitialAd();
      FacebookInterstitialAd.showInterstitialAd();
    }
  }

  void _loadInterstitialAd() {
    FacebookInterstitialAd.loadInterstitialAd(
      // placementId: "YOUR_PLACEMENT_ID",
      placementId: swaminarayanInterstialId,
      listener: (result, value) {

        print(">> FAN > Interstitial Ad: $result --> $value");
        if (result == InterstitialAdResult.LOADED) {
          _isInterstitialAdLoaded = true;
        }

        /// Once an Interstitial Ad has been dismissed and becomes invalidated,
        /// load a fresh Ad by calling this function.
        if (result == InterstitialAdResult.DISMISSED &&
            value["invalidated"] == true) {
          _isInterstitialAdLoaded = false;
          _loadInterstitialAd();
        }
      },
    );
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _videoController!.dispose();
  }

  Widget isPlaying() {
    return _videoController!.value.isPlaying && !isShowPlaying
        ? Container()
        : Icon(
            Icons.play_arrow,
            size: 80,
            color: Colors.white.withOpacity(0.5),
          );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _videoController!.value.isPlaying
              ? _videoController!.pause()
              : _videoController!.play();
        });
      },
      child: RotatedBox(
        quarterTurns: -1,
        child: Scaffold(
          // floatingActionButton: Padding(
          //   padding: const EdgeInsets.only(bottom: 20.0),
          //   child: FloatingActionButton(
          //     onPressed: () {
          //       _videoController!.pause();
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => StatusGridBody(statusUrl: widget.statusUrl,title: swaminarayanStatus,)),
          //       );
          //       // Add your onPressed code here!
          //     },
          //     backgroundColor: Colors.deepOrange,
          //     child: const Icon(Icons.grid_on),
          //   ),
          // ),
          bottomNavigationBar: _buildOriginDesign(context),
          body: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(color: Colors.black),
                    child: Stack(
                      children: <Widget>[
                        VideoPlayer(_videoController!),
                        Center(
                          child: Container(
                            decoration: const BoxDecoration(),
                            child: isPlaying(),
                          ),
                        )
                      ],
                    ),
                  ),
                  downloading
                      ? Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            height: 150.0,
                            width: 200.0,
                            child: Card(
                              color: Colors.deepOrange.withOpacity(1),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:const <Widget>[
                                   CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                    SizedBox(
                                    height: 20.0,
                                  ),
                                  Text(
                                    "Downloading...",
                                    style:   TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                    SizedBox(
                                    height: 10.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              )),
        ),
      ),
    );
  }

  int _currentIndex = 0;
  bool downloading = false;
  var progressString = "";

  Widget _buildOriginDesign(context) {
    return CustomNavigationBar(
      iconSize: 30.0,
      selectedColor: Colors.white,
      strokeColor: Colors.white,
      unSelectedColor: Colors.white,
      backgroundColor: Colors.deepOrange,
      items: [
        CustomNavigationBarItem(
          icon: const Icon(Icons.home),
        ),
        CustomNavigationBarItem(
          icon: const Icon(Icons.download),
        ),
        // CustomNavigationBarItem(
        //   icon: const Icon(Icons.share),
        // ),
      ],
      currentIndex: _currentIndex,
      onTap: (index) async {
        setState(() {
          _currentIndex = index;
        });
        if (index == 0) {
          Navigator.pop(context);
        } else if (index == 1) {
          _saveNetworkVideo(widget.url);
        } else {
          final ByteData imageData =
              await NetworkAssetBundle(Uri.parse(widget.url)).load("");
          final Uint8List bytes = imageData.buffer.asUint8List();
          File file = File.fromRawPath(bytes);
          Share.shareFiles([file.path], text: 'Great picture');
        }
      },
    );
  }

  void _saveNetworkVideo(url) async {
    String path = url;
    setState(() {
      downloading = true;
    });
    GallerySaver.saveVideo(path, albumName: "jay_swaminarayan").then((bool? success) {
      setState(() {

        const snackBar = SnackBar(
          content: Text('Yay! Downloading completed!'),
        );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.

        downloading = false;
        progressString = "Completed";
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    });
  }

  // Future<void> downloadFile(url) async {
  //   try {
  //     var dir = await getExternalStorageDirectory();
  //     final File file = File(url);
  //     await dio.download(url, "${dir!.path}/jay_swaminarayan/${file.path.split('/').last}",
  //         onReceiveProgress: (rec, total) {
  //       setState(() {
  //         downloading = true;
  //         progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
  //       });
  //     });
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //   }
  //   setState(() {
  //     downloading = false;
  //     progressString = "Completed";
  //   });
  // }
}



