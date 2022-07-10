

import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:swaminarayancounter/Utility/api_url.dart';
import 'package:swaminarayancounter/app_drawer.dart';
import 'package:swaminarayancounter/constant.dart';
import 'package:http/http.dart' as http;
import 'package:swaminarayancounter/skeletons/skeletons_wallpaper.dart';

class Suvichar extends StatefulWidget {
  const Suvichar({Key? key}) : super(key: key);

  @override
  _SuvicharState createState() => _SuvicharState();
}

class _SuvicharState extends State<Suvichar> {
  List statusUrl = [];
  void fetchUrl() async {
    try {
      var response = await http.get(Uri.parse(AppUrl.suvicharApi),headers: {
        "Accept": "application/json",
        "Access-Control_Allow_Origin": "*"
      });

      setState(() {
        List newData = [];
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
        title: const Text(suvichar),
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
      body: statusUrl.isNotEmpty ? ListView.builder(
          itemCount: statusUrl.length,
          itemBuilder: (context,i) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 175,
            decoration: BoxDecoration(
              color: Colors.deepOrange,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("$suvichar ${i +1}",style: const TextStyle(color: Colors.white),),
                        InkWell(
                            onTap: () async {
                              var response = await get(Uri.parse(statusUrl[i]['url']));
                              final documentDirectory = (await getExternalStorageDirectory())!.path;
                              File imgFile = File('$documentDirectory/jaySwaminarayan.png');
                              imgFile.writeAsBytesSync(response.bodyBytes);

                              Share.shareFiles([File('$documentDirectory/jaySwaminarayan.png').path],
                              text: """$headerTitle
                              
💥Download Now💥

https://play.google.com/store/apps/details?id=com.truly.swaminarayancounter""",
                              );
                            },
                            child: const Icon(Icons.share,color: Colors.white,)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: CachedNetworkImage(
                      imageUrl: statusUrl[i]['url'],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: skeletonsSuvichar()
                      ),
                      errorWidget: (context, url, uri) => const Center(
                        child: Icon(
                          Icons.error_outline_rounded,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }) : ListView.builder(
          itemCount: 10,
          itemBuilder: (context,i) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: skeletonsSuvichar(),
            );
          }),
    );
  }
}
