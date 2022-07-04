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
import 'package:swaminarayancounter/custom_videoPlayer/video_player_grid_Item.dart';
import 'package:swaminarayancounter/skeletons/skeletons_wallpaper.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:cached_video_preview/cached_video_preview.dart';

class StatusGridBody extends StatefulWidget {
  final String title;
  final List statusUrl;
  const StatusGridBody({
    Key? key,
    required this.title,
    required this.statusUrl,
  }) : super(key: key);

  @override
  _StatusGridBodyState createState() => _StatusGridBodyState();
}

class _StatusGridBodyState extends State<StatusGridBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.home)),
          const SizedBox(width: customWidth)
        ],
      ),
      drawer: const AppDrawer(),
      body: SafeArea(child: Column(
        children: [
          // SizedBox(
          //   height: 30,
          //   child: Padding(
          //     padding: const EdgeInsets.only(left: 18.0),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         RichText(
          //           text: TextSpan(
          //             text: 'Total Status of ',
          //             style: const TextStyle(fontWeight: FontWeight.normal,color: Colors.black),
          //             children: <TextSpan>[
          //               TextSpan(text: ' ${widget.statusUrl.length}', style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
          //             ],
          //           ),
          //         )
          //       ],
          //     ),
          //   ),
          // ),
          // Expanded(
          //   child: ResponsiveGridList(
          //       desiredItemWidth: 100,
          //       minSpacing: 10,
          //       children: widget.statusUrl.map((i) {
          //         return InkWell(
          //           onTap: () {
          //             Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                   builder: (context) => Scaffold(body: RotatedBox(
          //                       quarterTurns: 1,
          //                       child: SingleVideoPlayerItem(url: i,id: ,)))),
          //             );
          //           },
          //           child: SizedBox(
          //             height: 180,
          //             width: MediaQuery.of(context).size.width,
          //             child: VideoPlayerGridItem(url: i),
          //           ),
          //         );
          //       }).toList()
          //   ),
          // ),
        ],
      )
      ),
    );
  }


}
