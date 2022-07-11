

import 'dart:convert';

import 'package:audio_session/audio_session.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';
import 'package:swaminarayancounter/MusicPlayer/common.dart';
import 'package:swaminarayancounter/Utility/api_url.dart';
import 'package:swaminarayancounter/Utility/env.dart';
import 'package:swaminarayancounter/app_drawer.dart';
import 'package:swaminarayancounter/constant.dart';

class Kirtan extends StatefulWidget {
  const Kirtan({Key? key}) : super(key: key);

  @override
  _KirtanState createState() => _KirtanState();
}

class _KirtanState extends State<Kirtan> {
  late AudioPlayer _hanumanChalisaPlayer;
  late FacebookBannerAd facebookBannerAd;
  List statusUrl = [];
  ConcatenatingAudioSource _playlist =   ConcatenatingAudioSource(children: []);
  void fetchUrl() async {
    try {
      var response = await http.get(Uri.parse(AppUrl.kirtanApi),headers: {
        "Accept": "application/json",
        "Access-Control_Allow_Origin": "*"
      });

      setState(() {
        List data = jsonDecode(response.body);
        statusUrl = data;
        _playlist = ConcatenatingAudioSource(children: [
          for(int i = 0; i < data.length; i++)
            AudioSource.uri(
              Uri.parse(data[i]['url']),
              tag: MediaItem(
                id: "${i + 1}",
                album: "kirtan",
                title: "${data[i]['title']}",
                artUri: Uri.parse(data[i]['url']),
              ),
            ),

        ]);
        _init();
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
    FacebookAudienceNetwork.init(
        iOSAdvertiserTrackingEnabled: true //default false
    );
    facebookBannerAd = FacebookBannerAd(
      placementId: swaminarayanBannerId,
      bannerSize: BannerSize.STANDARD,
      keepAlive: true,
      listener: (result,val) {},
    );
    _hanumanChalisaPlayer = AudioPlayer();

  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _hanumanChalisaPlayer.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
          if (kDebugMode) {
            print('A stream error occurred: $e');
          }
        });
    try {
      await _hanumanChalisaPlayer.setAudioSource(_playlist);
    } catch (e) {
      // Catch load errors: 404, invalid url ...
      if (kDebugMode) {
        print("Error loading playlist: $e");
      }
    }
  }

  @override
  void dispose() {
    _hanumanChalisaPlayer.dispose();
    super.dispose();
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _hanumanChalisaPlayer.positionStream,
          _hanumanChalisaPlayer.bufferedPositionStream,
          _hanumanChalisaPlayer.durationStream,
              (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle =
    const TextStyle(fontSize: fontSize, color: Colors.white);
    return statusUrl.isNotEmpty ? Scaffold(
        bottomNavigationBar: Card(
          elevation: 5.0,
          child: SizedBox(
            height: 130,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                StreamBuilder<PositionData>(
                  stream: _positionDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    return SeekBar(
                      duration: positionData?.duration ?? Duration.zero,
                      position: positionData?.position ?? Duration.zero,
                      bufferedPosition:
                      positionData?.bufferedPosition ?? Duration.zero,
                      onChangeEnd: (newPosition) {
                        _hanumanChalisaPlayer.seek(newPosition);
                      },
                    );
                  },
                ),
                ControlButtons(_hanumanChalisaPlayer),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          elevation: 0.0,
          title: const Text(kirtan),
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
        body: StreamBuilder<SequenceState?>(
            stream: _hanumanChalisaPlayer.sequenceStateStream,
            builder: (context, snapshot) {
              final state = snapshot.data;
              if (state?.sequence.isEmpty ?? true) return const SizedBox();
              final metadata = state!.currentSource!.tag as MediaItem;
              print("metaData => ${metadata.id}");
              return Center(
                child: ListView.builder(
                  itemCount: statusUrl.length,
                  itemBuilder: (context,index){
                    return Builder(builder: (context){
                      if(index % 10 == 0) {
                        return Column(
                          children: [
                            facebookBannerAd,
                            const SizedBox(height: 18.0),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                  color: int.parse(metadata.id) == index + 1
                                      ? Colors.green
                                      : Colors.deepOrange.shade400,
                                  child: InkWell(
                                    child: ListTile(
                                        onTap: () async {
                                          await _hanumanChalisaPlayer.seek(
                                              const Duration(milliseconds: 0),
                                              index: index);
                                        },
                                        title: Text("${statusUrl[index]['title']}", style: textStyle),
                                        trailing: InkWell(
                                            onTap: null,
                                            child: Container(height: 35,width: 60,child:const Center(child: Text("Play")),decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),))),
                                  )),
                            ),
                          ],
                        );
                      }else{
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                              color: int.parse(metadata.id) == index + 1
                                  ? Colors.green
                                  : Colors.deepOrange.shade400,
                              child: InkWell(
                                child: ListTile(
                                    onTap: () async {
                                      await _hanumanChalisaPlayer.seek(
                                          const Duration(milliseconds: 0),
                                          index: index);
                                    },
                                    title: Text("${statusUrl[index]['title']}", style: textStyle),
                                    trailing: InkWell(
                                        onTap: null,
                                        child: Container(height: 35,width: 60,child:const Center(child: Text("Play")),decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),))),
                              )),
                        );
                      }
                    });
                  },
                ),
              );
            }

        )) :   Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(kirtan),
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
      body: const Center(child: Text("No Data"),),);
  }
}
