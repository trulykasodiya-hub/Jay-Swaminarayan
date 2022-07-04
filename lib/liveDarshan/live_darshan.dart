import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:swaminarayancounter/Utility/api_url.dart';
import 'package:swaminarayancounter/app_drawer.dart';
import 'package:swaminarayancounter/constant.dart';
import 'package:swaminarayancounter/liveDarshan/view_live_darshan.dart';
import 'package:http/http.dart' as http;
class LiveDarshan extends StatefulWidget {
  const LiveDarshan({Key? key}) : super(key: key);

  @override
  _LiveDarshanState createState() => _LiveDarshanState();
}

class _LiveDarshanState extends State<LiveDarshan> {

  List statusUrl = [];
  void fetchUrl() async {
    try {
      var response = await http.get(Uri.parse(AppUrl.liveDarshanStatus),headers: {
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
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(liveDarshan),
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
      body: GridView.builder(
        primary: false,
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),

        itemCount: statusUrl.length,
          itemBuilder: (BuildContext ctx, i) {
            return statusUrl.isNotEmpty ? InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewLiveDarshan(
                          youtubeId: statusUrl[i]['url'], place: statusUrl[i]['name'])),
                );
              },
              child: Card(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child:  Center(
                      child: Text(statusUrl[i]['name'],
                          style:const TextStyle(
                              fontSize: fontSize, color: Colors.white))),
                ),
              ),
            ) : const Center(child: CircularProgressIndicator());
          }
      ),
    );
  }
}
