import 'dart:convert';
import 'dart:io';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:swaminarayancounter/Controller/AppNotifications.dart';
import 'package:swaminarayancounter/Controller/ad_helper.dart';
import 'package:swaminarayancounter/EventPage/Event_Video_details.dart';
import 'package:swaminarayancounter/NotificationPage/NotificationPage.dart';
import 'package:swaminarayancounter/Utility/api_url.dart';
import 'package:swaminarayancounter/Utility/env.dart';
import 'package:swaminarayancounter/app_drawer.dart';
import 'package:swaminarayancounter/constant.dart';
import 'package:swaminarayancounter/MantraJap/mantra_jap.dart';
import 'package:swaminarayancounter/hanumanchalisa/hanuman_chalisa.dart';
import 'package:swaminarayancounter/hindola_kirtan/hindola_kirtan.dart';
import 'package:swaminarayancounter/janmangalNamavali/janmangal_namavali.dart';
import 'package:swaminarayancounter/kirtan/kirtan.dart';
import 'package:swaminarayancounter/liveDarshan/live_darshan.dart';
import 'package:swaminarayancounter/main.dart';
import 'package:swaminarayancounter/nitya_niyam/nitya_niyam.dart';
import 'package:swaminarayancounter/prabhatiya/prabhatiya.dart';
import 'package:swaminarayancounter/rington/rington.dart';
import 'package:swaminarayancounter/sikshapatri/sikshapatri.dart';
import 'package:swaminarayancounter/suvichar/suvichar.dart';
import 'package:swaminarayancounter/swaminarayanWallpaper/swaminarayan_wallpaper.dart';
import 'package:swaminarayancounter/whatsapp_video/whatsapp_video.dart';
import 'package:http/http.dart' as http;
import 'Utility/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  // TODO: Add _bannerAd
  late BannerAd _bannerAd;
  late FacebookBannerAd facebookBannerAd;

  // TODO: Add _isBannerAdReady
  bool _isBannerAdReady = false;

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }

  // TODO : EVENT
  List statusUrl = [];
  void fetchUrl() async {
    try {
      var response = await http.get(Uri.parse(AppUrl.eventsApi),headers: {
        "Accept": "application/json",
        "Access-Control_Allow_Origin": "*"
      });
      setState(() {
        List data = jsonDecode(response.body);
        statusUrl = data;
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
    AppNotifications.init();
    WidgetsBinding.instance!.addObserver(this);
    this.initNotification();

    ///  storage permission..
    _requestPermission();

    FacebookAudienceNetwork.init(
        iOSAdvertiserTrackingEnabled: true //default false
    );

    facebookBannerAd = FacebookBannerAd(
        placementId: swaminarayanBannerId,
        bannerSize: BannerSize.STANDARD,
        keepAlive: true,
        listener: (result,val) {},
    );

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

  void initNotification() async {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
          print("hello1");
          if(message != null) {
            if(message.data['data_type'] == "nityaNiyam") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NityaNiyam()),
              );
            }else if(message.data['data_type'] == "janmangal") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const JanmangalNamavaliPage()),
              );
            }else if(message.data['data_type'] == "hanumanChalisha") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HanumanChalisa()),
              );
            }else if(message.data['data_type'] == "liveDarshan") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LiveDarshan()),
              );
            }else if(message.data['data_type'] == "wallPaper") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SwaminarayanWallpaper()),
              );
            }else if(message.data['data_type'] == "whatsappStatus") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WhatsAppStatus()),
              );
            }else if(message.data['data_type'] == "rington") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Rington()),
              );
            }else if(message.data['data_type'] == "suvichar") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Suvichar()),
              );
            }else if(message.data['data_type'] == "kirtan") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Kirtan()),
              );
            }else if(message.data['data_type'] == "prabhatiya") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Prabhatiya()),
              );
            }else{
              List getNotificationList = [];
              setState(() {
                JaySwaminarayan.newNotification = true;
                getNotificationList = prefs.getString(notificationIdKey) != null ? jsonDecode(prefs.getString(notificationIdKey)!) : [];
                if(getNotificationList.length == 20) {
                  UserPreferences().removeNotification();
                  getNotificationList = [];
                }
                var newData = {
                  "title": message.notification!.title.toString(),
                  "body": message.notification!.body.toString(),
                  "image": message.data["image"] != null ? message.data['image'].toString() : null,
                };
                getNotificationList.insert(0,newData);
              });

              UserPreferences().saveNotification(jsonEncode(getNotificationList));
            }
          }

        //print("RemoteMessage => ${message!.data}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("hello2 => ${message.data['data_type']}");
      if(message.data['data_type'] == "nityaNiyam") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NityaNiyam()),
        );
      }else if(message.data['data_type'] == "janmangal") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const JanmangalNamavaliPage()),
        );
      }else if(message.data['data_type'] == "hanumanChalisha") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HanumanChalisa()),
        );
      }else if(message.data['data_type'] == "liveDarshan") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LiveDarshan()),
        );
      }else if(message.data['data_type'] == "wallPaper") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SwaminarayanWallpaper()),
        );
      }else if(message.data['data_type'] == "whatsappStatus") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WhatsAppStatus()),
        );
      }else if(message.data['data_type'] == "rington") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Rington()),
        );
      }else if(message.data['data_type'] == "suvichar") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Suvichar()),
        );
      }else if(message.data['data_type'] == "kirtan") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Kirtan()),
        );
      }else if(message.data['data_type'] == "prabhatiya") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Prabhatiya()),
        );
      }else{
        List getNotificationList = [];
        setState(() {
          JaySwaminarayan.newNotification = true;
          getNotificationList = prefs.getString(notificationIdKey) != null ? jsonDecode(prefs.getString(notificationIdKey)!) : [];
          if(getNotificationList.length == 20) {
            UserPreferences().removeNotification();
            getNotificationList = [];
          }
          var newData = {
            "title": message.notification!.title.toString(),
            "body": message.notification!.body.toString(),
            "image": message.data["image"] != null ? message.data['image'].toString() : null,
          };
          getNotificationList.insert(0,newData);
        });

        UserPreferences().saveNotification(jsonEncode(getNotificationList));
      }
      //print("onMessageOpenedApp => ${message.data}");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if(message.data['data_type'] == "nityaNiyam") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NityaNiyam()),
        );
      }else if(message.data['data_type'] == "janmangal") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const JanmangalNamavaliPage()),
        );
      }else if(message.data['data_type'] == "hanumanChalisha") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HanumanChalisa()),
        );
      }else if(message.data['data_type'] == "liveDarshan") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LiveDarshan()),
        );
      }else if(message.data['data_type'] == "wallPaper") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SwaminarayanWallpaper()),
        );
      }else if(message.data['data_type'] == "whatsappStatus") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WhatsAppStatus()),
        );
      }else if(message.data['data_type'] == "rington") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Rington()),
        );
      }else if(message.data['data_type'] == "suvichar") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Suvichar()),
        );
      }else if(message.data['data_type'] == "kirtan") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Kirtan()),
        );
      }else if(message.data['data_type'] == "prabhatiya") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Prabhatiya()),
        );
      }else{
        print("hello3 => ${message.notification!.title.toString()}");
        List getNotificationList = [];
        setState(() {
          JaySwaminarayan.newNotification = true;
          getNotificationList = prefs.getString(notificationIdKey) != null ? jsonDecode(prefs.getString(notificationIdKey)!) : [];
          if(getNotificationList.length == 20) {
            UserPreferences().removeNotification();
            getNotificationList = [];
          }
          var newData = {
            "title": message.notification!.title.toString(),
            "body": message.notification!.body.toString(),
            "image": message.data["image"] != null ? message.data['image'].toString() : null,
          };
          print("newData => $newData");
          getNotificationList.insert(0,newData);
          print("newData => $getNotificationList");
        });

        UserPreferences().saveNotification(jsonEncode(getNotificationList));
      }
     // print("onMessage => ${event.data}");
    });
  }

  ///  storage permission..
  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.notification,
    ].request();
    return statuses;
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    _bannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle =
        const TextStyle(fontSize: fontSize * 1.5, color: Colors.white);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(widget.title),
        actions: [
          const NotificationButton(),
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
        child: RefreshIndicator(
        onRefresh: () {
         return Future.delayed(const Duration(seconds: 1), () {
               fetchUrl();
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(padding),
            child: Center(
              child: ListView(
                children: <Widget>[
                  statusUrl.isNotEmpty ? imageSlider() : const SizedBox(height: 0),
                  const SizedBox(height: customHeight),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HindolaKirtan()),
                      );
                    },
                    child: Card(
                      color: Colors.deepOrange,
                      child: SizedBox(
                        height: 100,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(padding*2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(hindodaKirtan,style: textStyle),
                                const Icon(Icons.check_circle_outline,color: Colors.white)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: customHeight / 2),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Prabhatiya()),
                      );
                    },
                    child: Card(
                      color: Colors.deepOrange,
                      child: SizedBox(
                        height: 100,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(padding*2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(prabhatiya,style: textStyle),
                                const Icon(Icons.check_circle_outline,color: Colors.white)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: customHeight / 2),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LiveDarshan()),
                      );
                    },
                    child: Card(
                      color: Colors.deepOrange,
                      child: SizedBox(
                        height: 100,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(padding * 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(liveDarshan, style: textStyle),
                                const Icon(Icons.check_circle_outline,
                                    color: Colors.white)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: customHeight / 2),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MantraJap()),
                      );
                    },
                    child: Card(
                      color: Colors.deepOrange,
                      child: SizedBox(
                        height: 100,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(padding * 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(mantraJap, style: textStyle),
                                const Icon(Icons.check_circle_outline,
                                    color: Colors.white)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: customHeight / 2),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const JanmangalNamavaliPage()),
                      );
                    },
                    child: Card(
                      color: Colors.deepOrange,
                      child: SizedBox(
                        height: 100,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(padding * 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(janmangalNamavali, style: textStyle),
                                const Icon(Icons.check_circle_outline,
                                    color: Colors.white)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: customHeight / 2),
                  facebookBannerAd,
                  const SizedBox(height: customHeight / 2),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Sikshapatri()),
                      );
                    },
                    child: Card(
                      color: Colors.deepOrange,
                      child: SizedBox(
                        height: 100,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(padding * 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(sikshapatri, style: textStyle),
                                const Icon(Icons.check_circle_outline,
                                    color: Colors.white)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: customHeight / 2),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NityaNiyam()),
                      );
                    },
                    child: Card(
                      color: Colors.deepOrange,
                      child: SizedBox(
                        height: 100,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(padding * 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(nityaNiyam, style: textStyle),
                                const Icon(Icons.check_circle_outline,
                                    color: Colors.white)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: customHeight / 2),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HanumanChalisa()),
                      );
                    },
                    child: Card(
                      color: Colors.deepOrange,
                      child: SizedBox(
                        height: 100,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(padding*2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(hanumanChalisa,style: textStyle),
                                const Icon(Icons.check_circle_outline,color: Colors.white)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: customHeight / 2),
                  facebookBannerAd,
                  const SizedBox(height: customHeight / 2),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SwaminarayanWallpaper()),
                      );
                    },
                    child: Card(
                      color: Colors.deepOrange,
                      child: SizedBox(
                        height: 100,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(padding*2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(wallpaper,style: textStyle),
                                const Icon(Icons.check_circle_outline,color: Colors.white)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: customHeight/2),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WhatsAppStatus()),
                      );
                    },
                    child: Card(
                      color: Colors.deepOrange,
                      child: SizedBox(
                        height: 100,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(padding * 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(whatsappStatus, style: textStyle),
                                const Icon(Icons.check_circle_outline,
                                    color: Colors.white)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: customHeight/2),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Rington()),
                      );
                    },
                    child: Card(
                      color: Colors.deepOrange,
                      child: SizedBox(
                        height: 100,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(padding*2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(rington,style: textStyle),
                                const Icon(Icons.check_circle_outline,color: Colors.white)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: customHeight / 2),
                  facebookBannerAd,
                  const SizedBox(height: customHeight / 2),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Suvichar()),
                      );
                    },
                    child: Card(
                      color: Colors.deepOrange,
                      child: SizedBox(
                        height: 100,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(padding*2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(suvichar,style: textStyle),
                                const Icon(Icons.check_circle_outline,color: Colors.white)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: customHeight/2),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Kirtan()),
                      );
                    },
                    child: Card(
                      color: Colors.deepOrange,
                      child: SizedBox(
                        height: 100,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(padding*2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(kirtan,style: textStyle),
                                const Icon(Icons.check_circle_outline,color: Colors.white)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: customHeight/2),
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
                  const SizedBox(height: customHeight * 5),
                ],
              ),
            ),
          ),
        ),
      ),
      // floatingActionButton: const FloatingActionButton(
      //   onPressed: null,
      //   tooltip: 'Help',
      //   child: Icon(Icons.help),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget imageSlider() {
    return Padding(
        padding: const EdgeInsets.all(0),
        child: ImageSlideshow(
          width: double.infinity,
          height: 200,
          initialPage: 0,
          indicatorColor: Colors.deepOrange,
          indicatorBackgroundColor: Colors.grey,
          children: [
            for(int i = 0; i< statusUrl.length; i++)
            InkWell(
              onTap: () {
                if(statusUrl[i]['event_type'] == "video"){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EventVideoDetails(data: statusUrl[i])),
                  );
                }else{
                  if(statusUrl[i]['event_name'] == "nityaNiyam"){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NityaNiyam()),
                    );
                  }else if(statusUrl[i]['event_name'] == "liveDarshan"){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LiveDarshan()),
                    );
                  }else if(statusUrl[i]['event_name'] == "hindolaKirtan"){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HindolaKirtan()),
                    );
                  }else if(statusUrl[i]['event_name'] == "prabhatiya"){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Prabhatiya()),
                    );
                  }else if(statusUrl[i]['event_name'] == "sikshapatri"){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Sikshapatri()),
                    );
                  }else if(statusUrl[i]['event_name'] == "hanumanChalisha"){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HanumanChalisa()),
                    );
                  }else if(statusUrl[i]['event_name'] == "wallpaper"){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SwaminarayanWallpaper()),
                    );
                  }else if(statusUrl[i]['event_name'] == "whatsappStatus"){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const WhatsAppStatus()),
                    );
                  }else if(statusUrl[i]['event_name'] == "rington"){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Rington()),
                    );
                  }else if(statusUrl[i]['event_name'] == "suvichar"){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Suvichar()),
                    );
                  }else if(statusUrl[i]['event_name'] == "kirtan"){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Kirtan()),
                    );
                  }
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                  colorFilter:
                  ColorFilter.mode(Colors.black.withOpacity(statusUrl[i]['event_type'] == "video" ? 0.5 : 0.0),
                  BlendMode.darken),
                    image: NetworkImage(
                        '${statusUrl[i]['url']}'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(radius),
                ),
                child: statusUrl[i]['event_type'] == "video" ? statusUrl[i]['isLive'] == "1" ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(Icons.video_call,size: 30.0,color: Colors.white,),
                    SizedBox(height: 2,width: 0,),
                    Text("LIVE",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),)
                  ],
                ) : const Icon(Icons.video_call,size: 50.0,color: Colors.white,) : SizedBox(height: 0,width: 0,)
              ),
            )
          ],
          onPageChanged: (value) {
            if (kDebugMode) {
              print('Page changed: $value');
            }
          },
          autoPlayInterval: 3000,
          isLoop: true,
        )
    );
  }
}
