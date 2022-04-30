import 'dart:io';
import 'dart:typed_data';

import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'package:video_player/video_player.dart';

class SwaminarayanStatus extends StatefulWidget {
  const SwaminarayanStatus({Key? key}) : super(key: key);
  @override
  State<SwaminarayanStatus> createState() => _SwaminarayanStatusState();
}

class _SwaminarayanStatusState extends State<SwaminarayanStatus> {
  @override
  Widget build(BuildContext context) {
    final List<String> statusUrl = <String>[
      "https://res.cloudinary.com/cloudinarydashboard-one/video/upload/v1651119320/swaminarayan%20_%20status/WhatsApp_Video_2022-04-11_at_5.48.59_PM_tvnlxc.mp4",
      "https://res.cloudinary.com/cloudinarydashboard-one/video/upload/v1651118505/swaminarayan%20_%20status/WhatsApp_Video_2022-04-28_at_9.24.53_AM_cx8ggr.mp4",
      "https://res.cloudinary.com/cloudinarydashboard-one/video/upload/v1651119320/swaminarayan%20_%20status/WhatsApp_Video_2022-04-11_at_5.48.59_PM_tvnlxc.mp4",
    ];
    return Scaffold(
        extendBody: true, body: SwaminarayanStatusBody(statusUrl: statusUrl));
  }
}

class SwaminarayanStatusBody extends StatefulWidget {
  final Controller? testingController;
  final List<String> statusUrl;
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
              return VideoPlayerItem(url: widget.statusUrl[index]);
            },
          ),
        ),
      ),
    );
  }
}

class VideoPlayerItem extends StatefulWidget {
  final String url;
  const VideoPlayerItem({Key? key, required this.url}) : super(key: key);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  VideoPlayerController? _videoController;
  bool isShowPlaying = false;
  Dio dio = Dio();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _videoController = VideoPlayerController.network(widget.url)
      ..initialize().then((value) {
        _videoController!.play();
        setState(() {
          isShowPlaying = false;
        });
      });
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
          bottomNavigationBar: _buildOriginDesign(),
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
                                children: <Widget>[
                                  const CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  Text(
                                    "Downloading : $progressString",
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
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

  Widget _buildOriginDesign() {
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
          downloadFile(widget.url);
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

  Future<void> downloadFile(url) async {
    try {
      var dir = await getApplicationDocumentsDirectory();
      final File file = File(url);
      await dio.download(url, "${dir.path}/${file.path.split('/').last}",
          onReceiveProgress: (rec, total) {
        setState(() {
          downloading = true;
          progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    setState(() {
      downloading = false;
      progressString = "Completed";
    });
  }
}
