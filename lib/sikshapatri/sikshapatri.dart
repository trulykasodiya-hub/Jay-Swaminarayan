import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:swaminarayancounter/app_drawer.dart';
import 'package:swaminarayancounter/constant.dart';
import 'package:swaminarayancounter/sikshapatri/sikshapatri_data.dart';

class Sikshapatri extends StatefulWidget {
  const Sikshapatri({Key? key}) : super(key: key);

  @override
  _SikshapatriState createState() => _SikshapatriState();
}

class _SikshapatriState extends State<Sikshapatri> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(sikshapatri),
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
      body: SafeArea(
        child: ListView.builder(
            itemCount: sikshapatriData.length,
            itemBuilder: (context, i) {
              return Card(
                  child: ListTile(
                leading: Text(
                  "${sikshapatriData[i]['id']}",
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                title: Padding(
                  padding: const EdgeInsets.symmetric(vertical: padding / 2),
                  child: Text(
                    "${sikshapatriData[i]['slok']}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.symmetric(vertical: padding / 2),
                  child: Text(
                    "${sikshapatriData[i]['gujaratiAnuvad']}",
                    style: const TextStyle(color: Colors.white),
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
                        text: """${sikshapatriData[i]['slok']}
                        
${sikshapatriData[i]['gujaratiAnuvad']}||${sikshapatriData[i]['id']}||

💥Download Now💥

https://play.google.com/store/apps/details?id=com.truly.swaminarayancounter""",
                      );
                    }else if(v == 2) {
                      Clipboard.setData(ClipboardData(text: """${sikshapatriData[i]['slok']}
                        
${sikshapatriData[i]['gujaratiAnuvad']}||${sikshapatriData[i]['id']}||

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
