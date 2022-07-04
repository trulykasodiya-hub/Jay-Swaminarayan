import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:share_plus/share_plus.dart';
import 'package:swaminarayancounter/Utility/api_url.dart';
import 'package:swaminarayancounter/app_drawer.dart';
import 'package:swaminarayancounter/constant.dart';
import 'package:swaminarayancounter/custom_videoPlayer/SingleVideoPlayerItem.dart';
import 'package:swaminarayancounter/skeletons/skeletons_wallpaper.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:cached_video_preview/cached_video_preview.dart';

class VideoPlayerGridItem extends StatefulWidget {
  final String url;
  const VideoPlayerGridItem({Key? key, required this.url}) : super(key: key);

  @override
  _VideoPlayerGridItemState createState() => _VideoPlayerGridItemState();
}

class _VideoPlayerGridItemState extends State<VideoPlayerGridItem> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(color: Colors.black),
      child: CachedVideoPreviewWidget(
        path: widget.url,
        type: SourceType.remote,
        placeHolder: skeletonsWallpaper(),
        httpHeaders: const <String, String>{},
        remoteImageBuilder: (BuildContext context, url) =>
            Image.network(url,fit: BoxFit.cover,),
      ),
    );
  }
}
