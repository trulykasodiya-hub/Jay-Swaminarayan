import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share_plus/share_plus.dart';
import 'package:swaminarayancounter/MusicPlayer/common.dart';
import 'package:swaminarayancounter/app_drawer.dart';
import 'package:swaminarayancounter/constant.dart';
import 'package:swaminarayancounter/janmangalNamavali/janmangal_namavali_list.dart';

class JanmangalNamavaliPage extends StatelessWidget {
  const JanmangalNamavaliPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle =
    const TextStyle(fontSize: fontSize * 1.5, color: Colors.white);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(janmangalPath),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              icon: const Icon(Icons.home)),
          const SizedBox(width: customWidth)
        ],
      ),
      drawer: const AppDrawer(),
      body: ListView(
        children: [
          const SizedBox(height: customHeight/2),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const JanmangalNamavali()),
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
          const SizedBox(height: customHeight/2),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const JanmangalStrot()),
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
                        Text(janmangalStrot,style: textStyle),
                        const Icon(Icons.check_circle_outline,color: Colors.white)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: customHeight/2),
        ],
      ),
    );
  }
}

class JanmangalStrot extends StatefulWidget {
  const JanmangalStrot({Key? key}) : super(key: key);

  @override
  State<JanmangalStrot> createState() => _JanmangalStrotState();
}

class _JanmangalStrotState extends State<JanmangalStrot> {
  late AudioPlayer _janmangalStrotPlayer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _janmangalStrotPlayer = AudioPlayer();
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _janmangalStrotPlayer.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
          if (kDebugMode) {
            print('A stream error occurred: $e');
          }
        });
    try {
      await _janmangalStrotPlayer.setUrl(janmangalStrotAudio);
    } catch (e) {
      // Catch load errors: 404, invalid url ...
      if (kDebugMode) {
        print("Error loading playlist: $e");
      }
    }
  }

  @override
  void dispose() {
    _janmangalStrotPlayer.dispose();
    super.dispose();
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _janmangalStrotPlayer.positionStream,
          _janmangalStrotPlayer.bufferedPositionStream,
          _janmangalStrotPlayer.durationStream,
              (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(janmangalStrot),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              icon: const Icon(Icons.home)),
          const SizedBox(width: customWidth)
        ],
      ),
      drawer: const AppDrawer(),
      bottomNavigationBar: Card(
        elevation: 5.0,
        child: SizedBox(
          height: 130,
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
                      _janmangalStrotPlayer.seek(newPosition);
                    },
                  );
                },
              ),
              ControlButtons(_janmangalStrotPlayer),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListView.builder(
            itemCount: janmangalNamavaliStrotData.length,
            itemBuilder: (context, i) {
              return Card(
                  child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.symmetric(vertical: padding / 2),
                  child: Text(
                    janmangalNamavaliStrotData[i],
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                trailing:  PopupMenuButton<int>(
                  icon: const Icon(Icons.more_vert,color: Colors.white),
                  itemBuilder: (context) => [
                    // popupmenu item 1
                    PopupMenuItem(
                      value: 1,
                      // row has two child icon and text.
                      child: Row(
                        children: const [
                          Icon(Icons.share),
                          SizedBox(
                            // sized box with width 10
                            width: 10,
                          ),
                          Text("શેર કરો")
                        ],
                      ),
                    ),
                    // popupmenu item 2
                    PopupMenuItem(
                      value: 2,
                      // row has two child icon and text
                      child: Row(
                        children: const [
                          Icon(Icons.copy),
                          SizedBox(
                            // sized box with width 10
                            width: 10,
                          ),
                          Text("કોપી કરો")
                        ],
                      ),
                    ),
                  ],
                  offset: const Offset(0, 50),
                  color: Colors.white,
                  elevation: 2,
                  onSelected: (v) async {
                    if(v == 1) {
                      final bytes = await rootBundle.load('assets/images/banner1.png');
                      final list = bytes.buffer.asUint8List();

                      final tempDir = await getTemporaryDirectory();
                      final file = await File('${tempDir.path}/jaySwaminarayan.jpg').create();
                      file.writeAsBytesSync(list);
                      Share.shareFiles([file.path],
                        text: """${janmangalNamavaliStrotData[i]}
                        
💥Download Now💥

https://play.google.com/store/apps/details?id=com.truly.swaminarayancounter""",
                      );
                    }else if(v == 2) {
                      Clipboard.setData(ClipboardData(text: """${janmangalNamavaliData[i]}
                      
💥Download Now💥

https://play.google.com/store/apps/details?id=com.truly.swaminarayancounter""")).then((value) {
                        const snackBar = SnackBar(
                          content: Text('Yay! કોપી થઈ ગયું.'),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      });
                    }
                  },
                ),
              ));
            }),
      ),
    );
  }
}

class JanmangalNamavali extends StatefulWidget {
  const JanmangalNamavali({Key? key}) : super(key: key);

  @override
  _JanmangalNamavaliState createState() => _JanmangalNamavaliState();
}

class _JanmangalNamavaliState extends State<JanmangalNamavali> {
  late AudioPlayer _janmangalNamavaliPlayer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _janmangalNamavaliPlayer = AudioPlayer();
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _janmangalNamavaliPlayer.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
          if (kDebugMode) {
            print('A stream error occurred: $e');
          }
        });
    try {
      await _janmangalNamavaliPlayer.setUrl(janmangalNamavaliAudio);
    } catch (e) {
      // Catch load errors: 404, invalid url ...
      if (kDebugMode) {
        print("Error loading playlist: $e");
      }
    }
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _janmangalNamavaliPlayer.positionStream,
          _janmangalNamavaliPlayer.bufferedPositionStream,
          _janmangalNamavaliPlayer.durationStream,
              (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  void dispose() {
    _janmangalNamavaliPlayer.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(janmangalNamavali),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              icon: const Icon(Icons.home)),
          const SizedBox(width: customWidth)
        ],
      ),
      drawer: const AppDrawer(),
      bottomNavigationBar: Card(
        elevation: 5.0,
        child: SizedBox(
          height: 130,
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
                      _janmangalNamavaliPlayer.seek(newPosition);
                    },
                  );
                },
              ),
              ControlButtons(_janmangalNamavaliPlayer),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListView.builder(
            itemCount: janmangalNamavaliData.length,
            itemBuilder: (context, i) {
              return Card(
                  child: ListTile(
                leading: Text(
                  "${i + 1}",
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                title: Padding(
                  padding: const EdgeInsets.symmetric(vertical: padding / 2),
                  child: Text(
                    janmangalNamavaliData[i],
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                trailing: IconButton(onPressed: () async {
                  Clipboard.setData(ClipboardData(text: """${janmangalNamavaliData[i]}
                  
💥Download Now💥

https://play.google.com/store/apps/details?id=com.truly.swaminarayancounter""")).then((value) {
                    const snackBar = SnackBar(
                      content: Text('Yay! કોપી થઈ ગયું.'),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  });
                }, icon: const Icon(Icons.copy,color: Colors.white)),
              ));
            }),
      ),
    );
  }
}
