import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:swaminarayancounter/Controller/ad_helper.dart';
import 'package:swaminarayancounter/MantraJap/view_mantra_jap.dart';
import 'package:swaminarayancounter/app_drawer.dart';
import 'package:swaminarayancounter/constant.dart';
import 'package:swaminarayancounter/model/mantra_jap_model.dart';

import '../Controller/database_helper.dart';

class MantraJap extends StatefulWidget {
  const MantraJap({Key? key}) : super(key: key);

  @override
  _MantraJapState createState() => _MantraJapState();
}

class _MantraJapState extends State<MantraJap> {
  // _scaffoldKey
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // Database
  final dbHelper = DatabaseHelper.instance;

  int _counter = 0;
  bool shouldPop = true;

  // ads
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createInterstitialAd();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            if (kDebugMode) {
              print('$ad loaded');
            }
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            if (kDebugMode) {
              print('InterstitialAd failed to load: $error.');
            }
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      if (kDebugMode) {
        print('Warning: attempt to show interstitial before loaded.');
      }
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {},
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        if (kDebugMode) {}
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  void _showMessageInScaffold(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showExitPopup(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0.0,
          title: const Text(mantraJap),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                icon: const Icon(Icons.home)),
            const SizedBox(width: customWidth),
            TextButton(
                onPressed: () async {
                  _showInterstitialAd();
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewMantraJap(
                              mantraJapCount: _counter,
                            )),
                  );
                  if (result != null) {
                    setState(() {
                      _counter = result;
                    });
                  }
                },
                child: const Text(
                  viewMantraJap,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            const SizedBox(width: customWidth)
          ],
        ),
        drawer: const AppDrawer(),
        body: Column(
          children: [
            Expanded(
                child: Card(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(swaminarayan,
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: customHeight * 2),
                    Text("$_counter",
                        style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            )),
            Expanded(
                child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: InkWell(
                          onTap: _resetMantraJap,
                          child: const Card(
                            child: Center(
                              child: Text("0",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: InkWell(
                          onTap: _showMyDialog,
                          child: const Card(
                            child: Center(
                              child: Text(saveMantraJap,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: _incrementCounter,
                    child: const Card(
                      child: Center(
                        child: Text(swaminarayan,
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: _counter != 0 ? false : true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(headerTitle),
          content: _counter != 0
              ? const Text("તમારા જાપ ને સેવ કરો.")
              : const Text(
                  "તમે કોઈ મંત્રજાપ કરેલ નથી.પેલા મંત્રજાપ કરો અને ફરીથી સેવ કરો."),
          actions: <Widget>[
            TextButton(
              child: const Text('પાછા જાવ'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            _counter != 0
                ? TextButton(
                    child: const Text('સેવ'),
                    onPressed: () {
                      _insert("$_counter", "${DateTime.now()}");
                      Navigator.pop(context, true);
                    },
                  )
                : const SizedBox(
                    height: 0,
                    width: 0,
                  ),
          ],
        );
      },
    );
  }

  Future<void> _resetMantraJap() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: _counter != 0 ? false : true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(headerTitle),
          content:
              const Text("શુ તમે તમારા મંત્રજાપ ને ફરીથી 0 કરવા માંગો છો."),
          actions: <Widget>[
            TextButton(
              child: const Text('હા'),
              onPressed: () {
                setState(() {
                  _counter = 0;
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('ના'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _insert(count, date) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnCount: count,
      DatabaseHelper.columnDate: date
    };
    MantraJapModel mantraJapModel = MantraJapModel.fromMap(row);
    await dbHelper.insert(mantraJapModel);
    setState(() {
      _counter = 0;
    });
    _showMessageInScaffold('તમારો મંત્રજાપ સાચવવા માં આવીયો છે.');
  }

  Future<bool> showExitPopup() async {
    if (_counter != 0) {
      _showMyDialog();
    }
    return shouldPop;
  }
}
