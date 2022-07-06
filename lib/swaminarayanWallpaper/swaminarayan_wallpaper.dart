import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:share_plus/share_plus.dart';
import 'package:swaminarayancounter/Utility/api_url.dart';
import 'package:swaminarayancounter/app_drawer.dart';
import 'package:swaminarayancounter/skeletons/skeletons_wallpaper.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';
import '../constant.dart';
import 'package:http/http.dart' as http;

class SwaminarayanWallpaper extends StatefulWidget {
  const SwaminarayanWallpaper({Key? key}) : super(key: key);

  @override
  _SwaminarayanWallpaperState createState() => _SwaminarayanWallpaperState();
}

class _SwaminarayanWallpaperState extends State<SwaminarayanWallpaper> {

  List<String> wallpaperUrl = [];
  void fetchUrl() async {
    try {
      var response = await http.get(Uri.parse(AppUrl.swaminarayanWallpaper),headers: {
        "Accept": "application/json",
        "Access-Control_Allow_Origin": "*"
      });

      setState(() {
        List data = jsonDecode(response.body);
        List<String> newData = [];
        for(int i = 0; i  < data.length; i++) {
          newData.add(data[i]['url']);
        }
        wallpaperUrl = newData;
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
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(wallpaper),
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
          SizedBox(
            height: 30,
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Total Wallpaper of ',
                      style: const TextStyle(fontWeight: FontWeight.normal,color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(text: ' ${wallpaperUrl.length}', style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ResponsiveGridList(
                desiredItemWidth: 100,
                minSpacing: 10,
                children: wallpaperUrl.map((i) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute<void>(
                          builder: (BuildContext context) {
                            return Scaffold(
                              appBar: AppBar(
                                title: const Text('સેટ વોલપેપર'),
                                actions: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(Icons.home)),
                                  IconButton(
                                      onPressed: () async {

                                        var response = await get(Uri.parse(i));
                                        final documentDirectory = (await getExternalStorageDirectory())!.path;
                                        File imgFile = new File('$documentDirectory/flutter.png');
                                        imgFile.writeAsBytesSync(response.bodyBytes);

                                        Share.shareFiles([File('$documentDirectory/flutter.png').path],
                                            text: headerTitle,
                                            );
                                        // final ByteData imageData =
                                        //     await NetworkAssetBundle(Uri.parse(i)).load("");
                                        // final Uint8List bytes = imageData.buffer.asUint8List();
                                         //File file = File.fromUri(Uri.(i));
                                        // Share.shareFiles([file.path], text: headerTitle);
                                        // Share.shareFiles(['${file.path}/image.jpg'], text: 'Great picture');
                                        //Share.share('check out my website https://example.com', subject: 'Look what I made!');
                                      },
                                      icon: const Icon(Icons.share)),
                                  const SizedBox(width: customWidth)
                                ],
                              ),
                              bottomNavigationBar: SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    showAdaptiveActionSheet(
                                      context: context,
                                      actions: <BottomSheetAction>[
                                        BottomSheetAction(
                                          title: const Text('Home Screen'),
                                          onPressed: () {
                                            _setWallpaper(WallpaperManagerFlutter.HOME_SCREEN,i);
                                          },
                                        ),
                                        BottomSheetAction(
                                          title: const Text('Lock Screen'),
                                          onPressed: () {
                                            _setWallpaper(WallpaperManagerFlutter.LOCK_SCREEN,i);
                                          },
                                        ),
                                        BottomSheetAction(
                                          title: const Text('Both Screen'),
                                          onPressed: () {
                                            _setWallpaper(WallpaperManagerFlutter.BOTH_SCREENS,i);
                                          },
                                        ),
                                      ],
                                      cancelAction: CancelAction(title: const Text('Cancel')),
                                    );
                                  },
                                  child: const Text('સેટ કરો'),
                                ),
                              ),
                              body: Column(
                                children: <Widget>[
                                  Expanded(
                                    flex: 4,
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: CachedNetworkImage(
                                        imageUrl: i,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, uri) => const Center(
                                          child: Icon(
                                            Icons.error_outline_rounded,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                      ));
                    },
                    child: Container(
                      height: 180,
                      child: CachedNetworkImage(
                        imageUrl: i,
                        height: 180,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => skeletonsWallpaper(),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  );
                }).toList()
            ),
          ),
        ],
      )
      ),
    );
  }


  Future<void> _setWallpaper(location,i) async {
    var file = await DefaultCacheManager().getSingleFile(i);
    try {
      WallpaperManagerFlutter().setwallpaperfromFile(file, location);
      ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(
          content: Text('Wallpaper updated'),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error Setting Wallpaper'),
        ),
      );
      Navigator.pop(context);
      print(e);
    }
  }

}

