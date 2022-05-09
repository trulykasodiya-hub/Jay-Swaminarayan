import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:swaminarayancounter/app_drawer.dart';
import 'package:swaminarayancounter/skeletons/skeletons_wallpaper.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';
import '../constant.dart';

class SwaminarayanWallpaper extends StatefulWidget {
  const SwaminarayanWallpaper({Key? key}) : super(key: key);

  @override
  _SwaminarayanWallpaperState createState() => _SwaminarayanWallpaperState();
}

class _SwaminarayanWallpaperState extends State<SwaminarayanWallpaper> {
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
      body: SafeArea(child: ResponsiveGridList(
          desiredItemWidth: 100,
          minSpacing: 10,
          children: [
            "https://res.cloudinary.com/ddedmrbj6/image/upload/v1651377608/wallpaper/ONE.jpg",
            "https://res.cloudinary.com/ddedmrbj6/image/upload/v1651377626/wallpaper/TWO.jpg",
            "https://res.cloudinary.com/ddedmrbj6/image/upload/v1651377642/wallpaper/THREE.jpg",
            "https://res.cloudinary.com/ddedmrbj6/image/upload/v1651377654/wallpaper/FOUR.jpg",
            "https://res.cloudinary.com/ddedmrbj6/image/upload/v1651377671/wallpaper/FIVE.jpg",
            "https://res.cloudinary.com/ddedmrbj6/image/upload/v1651377713/wallpaper/SIX.jpg",
            "https://res.cloudinary.com/ddedmrbj6/image/upload/v1651377732/wallpaper/SEVEN.webp",
            "https://res.cloudinary.com/ddedmrbj6/image/upload/v1651377748/wallpaper/EIGHT.jpg",
            "https://res.cloudinary.com/ddedmrbj6/image/upload/v1651377769/wallpaper/NINE.png",
            "https://res.cloudinary.com/ddedmrbj6/image/upload/v1651377788/wallpaper/TEN.jpg",
            "https://res.cloudinary.com/ddedmrbj6/image/upload/v1651377818/wallpaper/ELEVEN.png",
            "https://res.cloudinary.com/ddedmrbj6/image/upload/v1651377832/wallpaper/TWLELE.jpg"
          ].map((i) {
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error Setting Wallpaper'),
        ),
      );
      print(e);
    }
  }

}

