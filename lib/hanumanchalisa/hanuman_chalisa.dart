
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:swaminarayancounter/MusicPlayer/common.dart';
import 'package:swaminarayancounter/app_drawer.dart';
import 'package:swaminarayancounter/constant.dart';
import 'package:swaminarayancounter/hanumanchalisa/hanuman_chalisa_data.dart';

class HanumanChalisa extends StatefulWidget {
  const HanumanChalisa({Key? key}) : super(key: key);

  @override
  _HanumanChalisaState createState() => _HanumanChalisaState();
}

class _HanumanChalisaState extends State<HanumanChalisa> {
  late AudioPlayer _hanumanChalisaPlayer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _hanumanChalisaPlayer = AudioPlayer();
    _init();
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
      await _hanumanChalisaPlayer.setUrl(hanumanChalisha);
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
    return Scaffold(
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
        title: const Text(hanumanChalisa),
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
      body:const SingleChildScrollView(
        child:  Padding(
          padding: EdgeInsets.symmetric(vertical: padding / 2),
          child: Center(
            child: Text(
              hanumanChalisaData,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: fontSize)
            ),
          ),
        ),
      ),
    );
  }
}
