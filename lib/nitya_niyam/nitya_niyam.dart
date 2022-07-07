import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';
import 'package:swaminarayancounter/MusicPlayer/common.dart';
import 'package:swaminarayancounter/app_drawer.dart';
import 'package:swaminarayancounter/constant.dart';
import 'package:swaminarayancounter/nitya_niyam/nitya_niyam_data.dart';

class NityaNiyam extends StatefulWidget {
  const NityaNiyam({Key? key}) : super(key: key);

  @override
  State<NityaNiyam> createState() => _NityaNiyamState();
}

class _NityaNiyamState extends State<NityaNiyam> {
  late AudioPlayer _player;

  final _playlist = ConcatenatingAudioSource(children: [
    AudioSource.uri(
      Uri.parse(godiUrl),
      tag: MediaItem(
        id: '1',
        album: nityaNiyam,
        title: godi,
        artUri: Uri.parse(
            "https://drive.google.com/uc?export=download&id=14r_fMJr-nVlur4O8z0E_6vBy3U7209mF"),
      ),
    ),
    AudioSource.uri(
      Uri.parse(aratiUrl),
      tag: MediaItem(
        id: '2',
        album: nityaNiyam,
        title: arati,
        artUri: Uri.parse(
            "https://drive.google.com/uc?export=download&id=14r_fMJr-nVlur4O8z0E_6vBy3U7209mF"),
      ),
    ),
    AudioSource.uri(
      Uri.parse(ramKrishnaGovindUrl),
      tag: MediaItem(
        id: '3',
        album: nityaNiyam,
        title: ramKrishnaGovind,
        artUri: Uri.parse(
            "https://drive.google.com/uc?export=download&id=14r_fMJr-nVlur4O8z0E_6vBy3U7209mF"),
      ),
    ),
    AudioSource.uri(
      Uri.parse(navinjimutUrl),
      tag: MediaItem(
        id: '4',
        album: nityaNiyam,
        title: navinjimut,
        artUri: Uri.parse(
            "https://drive.google.com/uc?export=download&id=14r_fMJr-nVlur4O8z0E_6vBy3U7209mF"),
      ),
    ),
    AudioSource.uri(
      Uri.parse(nirvikalpUtamUrl),
      tag: MediaItem(
        id: '5',
        album: nityaNiyam,
        title: nirvikalpUtam,
        artUri: Uri.parse(
            "https://drive.google.com/uc?export=download&id=14r_fMJr-nVlur4O8z0E_6vBy3U7209mF"),
      ),
    ),
    AudioSource.uri(
      Uri.parse(slockUrl),
      tag: MediaItem(
        id: '6',
        album: nityaNiyam,
        title: slock,
        artUri: Uri.parse(
            "https://drive.google.com/uc?export=download&id=1xMNMFqkpVjsnMsph5WJvXLr7QL05BP3Q"),
      ),
    ),
    AudioSource.uri(
      Uri.parse(nityaNiayamUrl),
      tag: MediaItem(
        id: '7',
        album: nityaNiyam,
        title: nityaNiayam,
        artUri: Uri.parse(
            "https://drive.google.com/uc?export=download&id=14r_fMJr-nVlur4O8z0E_6vBy3U7209mF"),
      ),
    ),
    AudioSource.uri(
      Uri.parse(oraavoshyamUrl),
      tag: MediaItem(
        id: '8',
        album: nityaNiyam,
        title: oraavoshyam,
        artUri: Uri.parse(
            "https://drive.google.com/uc?export=download&id=14r_fMJr-nVlur4O8z0E_6vBy3U7209mF"),
      ),
    ),
    AudioSource.uri(
      Uri.parse(haveMaraValaUrl),
      tag: MediaItem(
        id: '9',
        album: nityaNiyam,
        title: haveMaraVala,
        artUri: Uri.parse(
            "https://drive.google.com/uc?export=download&id=14r_fMJr-nVlur4O8z0E_6vBy3U7209mF"),
      ),
    ),
    AudioSource.uri(
      Uri.parse(vanduUrl),
      tag: MediaItem(
        id: '10',
        album: nityaNiyam,
        title: vandu,
        artUri: Uri.parse(
            "https://drive.google.com/uc?export=download&id=1iJ7z92yR_-_6suJ1UFPCc2CTy3VH2dmK"),
      ),
    ),
    AudioSource.uri(
      Uri.parse(reShyamtaneUrl),
      tag: MediaItem(
        id: '11',
        album: nityaNiyam,
        title: reShyamtane,
        artUri: Uri.parse(
            "https://drive.google.com/uc?export=download&id=1AM5ZQ1BSshoq0GssZle2wL6uRSiwyOda"),
      ),
    ),
    AudioSource.uri(
      Uri.parse(podhePrbhuUrl),
      tag: MediaItem(
        id: '12',
        album: nityaNiyam,
        title: podhePrbhu,
        artUri: Uri.parse(
            "https://drive.google.com/uc?export=download&id=1Z6CRNbU-0Rcd4K5vE_uZc9HZqSuOAuVa"),
      ),
    ),
    AudioSource.uri(
      Uri.parse(podhopodhoUrl),
      tag: MediaItem(
        id: '13',
        album: nityaNiyam,
        title: podhopodho,
        artUri: Uri.parse(
            "https://drive.google.com/uc?export=download&id=1Z6CRNbU-0Rcd4K5vE_uZc9HZqSuOAuVa"),
      ),
    ),

  ]);

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      if (kDebugMode) {
        print('A stream error occurred: $e');
      }
    });
    try {
      await _player.setAudioSource(_playlist);
    } catch (e) {
      // Catch load errors: 404, invalid url ...
      if (kDebugMode) {
        print("Error loading playlist: $e");
      }
    }
  }

  @override
  void dispose() {
    // _player.dispose();
    super.dispose();
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle =
        const TextStyle(fontSize: fontSize, color: Colors.white);
    //print("_nextMediaId : $_nextMediaId");
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
                      _player.seek(newPosition);
                    },
                  );
                },
              ),
              ControlButtons(_player),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(nityaNiyam),
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(padding / 2),
          child: StreamBuilder<SequenceState?>(
            stream: _player.sequenceStateStream,
            builder: (context, snapshot) {
              final state = snapshot.data;
              if (state?.sequence.isEmpty ?? true) return const SizedBox();
              final metadata = state!.currentSource!.tag as MediaItem;
              return Center(
                child: ListView(
                  children: <Widget>[
                    const SizedBox(height: customHeight / 2),
                    Card(
                        color: int.parse(metadata.id) == 1
                            ? Colors.green
                            : Colors.deepOrange.shade400,
                        child: InkWell(
                          child: ListTile(
                              onTap: () {
                                nityaNiyamData(godi, godiData);
                              },
                              title: Text(godi, style: textStyle),
                              trailing: InkWell(
                                onTap: () async {
                                  await _player.seek(
                                      const Duration(milliseconds: 0),
                                      index: 0);
                                },
                                child: Icon(
                                    int.parse(metadata.id) != 1
                                        ? Icons.play_circle_fill
                                        : Icons.pause_circle_filled,
                                    color: Colors.white),
                              )),
                        )),
                    const SizedBox(height: customHeight / 2),
                    Card(
                        color: int.parse(metadata.id) == 2
                            ? Colors.green
                            : Colors.deepOrange.shade400,
                        child: InkWell(
                          child: ListTile(
                              onTap: () {
                                nityaNiyamData(arati, aratiData);
                              },
                              title: Text(arati, style: textStyle),
                              trailing: InkWell(
                                onTap: () async {
                                  await _player.seek(
                                      const Duration(milliseconds: 0),
                                      index: 1);
                                },
                                child: Icon(
                                    int.parse(metadata.id) != 2
                                        ? Icons.play_circle_fill
                                        : Icons.pause_circle_filled,
                                    color: Colors.white),
                              )),
                        )),
                    const SizedBox(height: customHeight / 2),
                    Card(
                        color: int.parse(metadata.id) == 3
                            ? Colors.green
                            : Colors.deepOrange.shade400,
                        child: InkWell(
                          child: ListTile(
                              onTap: () {
                                nityaNiyamData(
                                    ramKrishnaGovind, ramKrishnaGovindData);
                              },
                              title: Text(ramKrishnaGovind, style: textStyle),
                              trailing: InkWell(
                                onTap: () async {
                                  await _player.seek(
                                      const Duration(milliseconds: 0),
                                      index: 2);
                                },
                                child: Icon(
                                    int.parse(metadata.id) != 3
                                        ? Icons.play_circle_fill
                                        : Icons.pause_circle_filled,
                                    color: Colors.white),
                              )),
                        )),
                    const SizedBox(height: customHeight / 2),
                    Card(
                        color: int.parse(metadata.id) == 4
                            ? Colors.green
                            : Colors.deepOrange.shade400,
                        child: InkWell(
                          child: ListTile(
                              onTap: () {
                                nityaNiyamData(navinjimut, navinjimutData);
                              },
                              title: Text(navinjimut, style: textStyle),
                              trailing: InkWell(
                                onTap: () async {
                                  await _player.seek(
                                      const Duration(milliseconds: 0),
                                      index: 3);
                                },
                                child: Icon(
                                    int.parse(metadata.id) != 4
                                        ? Icons.play_circle_fill
                                        : Icons.pause_circle_filled,
                                    color: Colors.white),
                              )),
                        )),
                    const SizedBox(height: customHeight / 2),
                    Card(
                        color: int.parse(metadata.id) == 5
                            ? Colors.green
                            : Colors.deepOrange.shade400,
                        child: InkWell(
                          child: ListTile(
                              onTap: () {
                                nityaNiyamData(
                                    nirvikalpUtam, nirvikalpUtamData);
                              },
                              title: Text(nirvikalpUtam, style: textStyle),
                              trailing: InkWell(
                                onTap: () async {
                                  await _player.seek(
                                      const Duration(milliseconds: 0),
                                      index: 4);
                                },
                                child: Icon(
                                    int.parse(metadata.id) != 5
                                        ? Icons.play_circle_fill
                                        : Icons.pause_circle_filled,
                                    color: Colors.white),
                              )),
                        )),
                    const SizedBox(height: customHeight / 2),
                    Card(
                        color: int.parse(metadata.id) == 6
                            ? Colors.green
                            : Colors.deepOrange.shade400,
                        child: InkWell(
                          child: ListTile(
                              onTap: () {
                                nityaNiyamData(slock, slockData);
                              },
                              title: Text(slock, style: textStyle),
                              trailing: InkWell(
                                onTap: () async {
                                  await _player.seek(
                                      const Duration(milliseconds: 0),
                                      index: 5);
                                },
                                child: Icon(
                                    int.parse(metadata.id) != 6
                                        ? Icons.play_circle_fill
                                        : Icons.pause_circle_filled,
                                    color: Colors.white),
                              )),
                        )),
                    const SizedBox(height: customHeight / 2),
                    Card(
                        color: int.parse(metadata.id) == 7
                            ? Colors.green
                            : Colors.deepOrange.shade400,
                        child: InkWell(
                          child: ListTile(
                              onTap: () {
                                nityaNiyamData(nityaNiayam, nityaNiayamData);
                              },
                              title: Text(nityaNiayam, style: textStyle),
                              trailing: InkWell(
                                onTap: () async {
                                  await _player.seek(
                                      const Duration(milliseconds: 0),
                                      index: 6);
                                },
                                child: Icon(
                                    int.parse(metadata.id) != 7
                                        ? Icons.play_circle_fill
                                        : Icons.pause_circle_filled,
                                    color: Colors.white),
                              )),
                        )),
                    const SizedBox(height: customHeight / 2),
                    Card(
                        color: int.parse(metadata.id) == 8
                            ? Colors.green
                            : Colors.deepOrange.shade400,
                        child: InkWell(
                          child: ListTile(
                              onTap: () {
                                nityaNiyamData(oraavoshyam, oraavoshyamData);
                              },
                              title: Text(oraavoshyam, style: textStyle),
                              trailing: InkWell(
                                onTap: () async {
                                  await _player.seek(
                                      const Duration(milliseconds: 0),
                                      index: 7);
                                },
                                child: Icon(
                                    int.parse(metadata.id) != 8
                                        ? Icons.play_circle_fill
                                        : Icons.pause_circle_filled,
                                    color: Colors.white),
                              )),
                        )),
                    const SizedBox(height: customHeight / 2),
                    Card(
                        color: int.parse(metadata.id) == 9
                            ? Colors.green
                            : Colors.deepOrange.shade400,
                        child: InkWell(
                          child: ListTile(
                              onTap: () {
                                nityaNiyamData(haveMaraVala, haveMaraValaData);
                              },
                              title: Text(haveMaraVala, style: textStyle),
                              trailing: InkWell(
                                onTap: () async {
                                  await _player.seek(
                                      const Duration(milliseconds: 0),
                                      index: 8);
                                },
                                child: Icon(
                                    int.parse(metadata.id) != 9
                                        ? Icons.play_circle_fill
                                        : Icons.pause_circle_filled,
                                    color: Colors.white),
                              )),
                        )),
                    const SizedBox(height: customHeight / 2),
                    Card(
                        color: int.parse(metadata.id) == 10
                            ? Colors.green
                            : Colors.deepOrange.shade400,
                        child: InkWell(
                          child: ListTile(
                              onTap: () {
                                nityaNiyamData(vandu, vanduData);
                              },
                              title: Text(vandu, style: textStyle),
                              trailing: InkWell(
                                onTap: () async {
                                  await _player.seek(
                                      const Duration(milliseconds: 0),
                                      index: 9);
                                },
                                child: Icon(
                                    int.parse(metadata.id) != 10
                                        ? Icons.play_circle_fill
                                        : Icons.pause_circle_filled,
                                    color: Colors.white),
                              )),
                        )),
                    const SizedBox(height: customHeight / 2),
                    Card(
                        color: int.parse(metadata.id) == 11
                            ? Colors.green
                            : Colors.deepOrange.shade400,
                        child: InkWell(
                          child: ListTile(
                              onTap: () {
                                nityaNiyamData(reShyamtane, reShyamtaneData);
                              },
                              title: Text(reShyamtane, style: textStyle),
                              trailing: InkWell(
                                onTap: () async {
                                  await _player.seek(
                                      const Duration(milliseconds: 0),
                                      index: 10);
                                },
                                child: Icon(
                                    int.parse(metadata.id) != 11
                                        ? Icons.play_circle_fill
                                        : Icons.pause_circle_filled,
                                    color: Colors.white),
                              )),
                        )),
                    const SizedBox(height: customHeight /2),
                    Card(
                        color: int.parse(metadata.id) == 12
                            ? Colors.green
                            : Colors.deepOrange.shade400,
                        child: InkWell(
                          child: ListTile(
                              onTap: () {
                                nityaNiyamData(podhePrbhu, podhePrbhuData);
                              },
                              title: Text(podhePrbhu, style: textStyle),
                              trailing: InkWell(
                                onTap: () async {
                                  await _player.seek(
                                      const Duration(milliseconds: 0),
                                      index: 11);
                                },
                                child: Icon(
                                    int.parse(metadata.id) != 12
                                        ? Icons.play_circle_fill
                                        : Icons.pause_circle_filled,
                                    color: Colors.white),
                              )),
                        )),
                    const SizedBox(height: customHeight / 2),
                    Card(
                        color: int.parse(metadata.id) == 13
                            ? Colors.green
                            : Colors.deepOrange.shade400,
                        child: InkWell(
                          child: ListTile(
                              onTap: () {
                                nityaNiyamData(podhopodho, podhopodhoData);
                              },
                              title: Text(podhopodho, style: textStyle),
                              trailing: InkWell(
                                onTap: () async {
                                  await _player.seek(
                                      const Duration(milliseconds: 0),
                                      index: 12);
                                },
                                child: Icon(
                                    int.parse(metadata.id) != 13
                                        ? Icons.play_circle_fill
                                        : Icons.pause_circle_filled,
                                    color: Colors.white),
                              )),
                        )),
                    const SizedBox(height: customHeight * 2),

                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void nityaNiyamData(title, data) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height - 25,
            child: Scaffold(
              extendBody: true,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                elevation: 0.0,
                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: Colors.deepOrange,
                title: Text(
                  title,
                  style: const TextStyle(color: Colors.white),
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      icon: const Icon(
                        Icons.home,
                        color: Colors.white,
                      )),
                  const SizedBox(width: customWidth)
                ],
              ),
              drawer: const AppDrawer(),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: customHeight * 1.5),
                        Text(
                          data,
                          style: const TextStyle(fontSize: 15),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
