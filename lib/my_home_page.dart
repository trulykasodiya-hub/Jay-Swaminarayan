import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swaminarayancounter/Controller/AppNotifications.dart';
import 'package:swaminarayancounter/Controller/ad_helper.dart';
import 'package:swaminarayancounter/Utility/env.dart';
import 'package:swaminarayancounter/app_drawer.dart';
import 'package:swaminarayancounter/constant.dart';
import 'package:swaminarayancounter/MantraJap/mantra_jap.dart';
import 'package:swaminarayancounter/hanumanStatus/hanuman_status.dart';
import 'package:swaminarayancounter/hanumanchalisa/hanuman_chalisa.dart';
import 'package:swaminarayancounter/janmangalNamavali/janmangal_namavali.dart';
import 'package:swaminarayancounter/liveDarshan/live_darshan.dart';
import 'package:swaminarayancounter/mahadev_status/mahadev_status.dart';
import 'package:swaminarayancounter/nitya_niyam/nitya_niyam.dart';
import 'package:swaminarayancounter/radhaKrishanaStatus/radha_krishna_status.dart';
import 'package:swaminarayancounter/rington/rington.dart';
import 'package:swaminarayancounter/sikshapatri/sikshapatri.dart';
import 'package:swaminarayancounter/swaminarayanStatus/swaminarayan_status.dart';
import 'package:swaminarayancounter/swaminarayanWallpaper/swaminarayan_wallpaper.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    AppNotifications.init();
    WidgetsBinding.instance!.addObserver(this);
    initNotification();

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
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
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
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(padding),
        child: Center(
          child: ListView(
            children: <Widget>[
              const SizedBox(height: customHeight),
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
              const SizedBox(height: customHeight/2),
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
                        builder: (context) => const SwaminarayanStatus()),
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
                            Text(swaminarayanStatus, style: textStyle),
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
                        builder: (context) => const HanumanStatus()),
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
                            Text(hanumanStatus,style: textStyle),
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
                        builder: (context) => const MahadevStatus()),
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
                            Text(mahadevStatus,style: textStyle),
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
                        builder: (context) => const RadhaKrishnaStatus()),
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
                            Text(radhaKrishana,style: textStyle),
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
      // floatingActionButton: const FloatingActionButton(
      //   onPressed: null,
      //   tooltip: 'Help',
      //   child: Icon(Icons.help),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
