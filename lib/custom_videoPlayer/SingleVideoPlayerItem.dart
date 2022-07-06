import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:swaminarayancounter/Utility/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class SingleVideoPlayerItem extends StatefulWidget {
  final String url;
  final String id;
  final String feturesName;
  const SingleVideoPlayerItem({Key? key, required this.url,required this.id,required this.feturesName}) : super(key: key);

  @override
  _SingleVideoPlayerItemState createState() => _SingleVideoPlayerItemState();
}

class _SingleVideoPlayerItemState extends State<SingleVideoPlayerItem> {
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
        if(widget.feturesName == "hanumanStatus"){
          UserPreferences().saveHanumanStatusLastId(widget.id);
        }else if(widget.feturesName == "mahadevStatus"){
          UserPreferences().saveMahadevStatusLastId(widget.id);
        }else{
          UserPreferences().saveRadhaKrishnaStatusLastId(widget.id);
        }
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
                          children: <Widget>[
                            const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              "Downloading...",
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
  //     var dir = await getApplicationDocumentsDirectory();
  //     final File file = File(url);
  //     await dio.download(url, "${dir.path}/${file.path.split('/').last}",
  //         onReceiveProgress: (rec, total) {
  //           setState(() {
  //             downloading = true;
  //             progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
  //           });
  //         });
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
