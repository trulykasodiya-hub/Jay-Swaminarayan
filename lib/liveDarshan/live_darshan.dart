import 'package:flutter/material.dart';
import 'package:swaminarayancounter/app_drawer.dart';
import 'package:swaminarayancounter/constant.dart';
import 'package:swaminarayancounter/liveDarshan/view_live_darshan.dart';

class LiveDarshan extends StatefulWidget {
  const LiveDarshan({Key? key}) : super(key: key);

  @override
  _LiveDarshanState createState() => _LiveDarshanState();
}

class _LiveDarshanState extends State<LiveDarshan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(liveDarshan),
      ),
      drawer: const AppDrawer(),
      body: GridView.extent(
        primary: false,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        maxCrossAxisExtent: 200.0,
        children: <Widget>[
          // InkWell(
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => const ViewLiveDarshan(youtubeId: "XtCfGcD2GGo")),
          //     );
          //   },
          //   child: Card(
          //     child: Container(
          //       padding: const EdgeInsets.all(8),
          //       child: const Center(child:  Text(gadhpur, style: TextStyle(fontSize: fontSize,color: Colors.white))),
          //     ),
          //   ),
          // ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ViewLiveDarshan(
                        youtubeId: amdavadId, place: amdavad)),
              );
            },
            child: Card(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Center(
                    child: Text(amdavad,
                        style: TextStyle(
                            fontSize: fontSize, color: Colors.white))),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ViewLiveDarshan(
                        youtubeId: vadtalId, place: vadtal)),
              );
            },
            child: Card(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Center(
                    child: Text(vadtal,
                        style: TextStyle(
                            fontSize: fontSize, color: Colors.white))),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const ViewLiveDarshan(youtubeId: bhujId, place: bhuj)),
              );
            },
            child: Card(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Center(
                    child: Text(bhuj,
                        style: TextStyle(
                            fontSize: fontSize, color: Colors.white))),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ViewLiveDarshan(
                        youtubeId: junagadhId, place: junagadh)),
              );
            },
            child: Card(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Center(
                    child: Text(junagadh,
                        style: TextStyle(
                            fontSize: fontSize, color: Colors.white))),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const ViewLiveDarshan(youtubeId: muliId, place: muli)),
              );
            },
            child: Card(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Center(
                    child: Text(muli,
                        style: TextStyle(
                            fontSize: fontSize, color: Colors.white))),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ViewLiveDarshan(
                        youtubeId: sardarId, place: sardar)),
              );
            },
            child: Card(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Center(
                    child: Text(sardar,
                        style: TextStyle(
                            fontSize: fontSize, color: Colors.white))),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ViewLiveDarshan(
                        youtubeId: jetalpurId, place: jetalpur)),
              );
            },
            child: Card(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Center(
                    child: Text(jetalpur,
                        style: TextStyle(
                            fontSize: fontSize, color: Colors.white))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
