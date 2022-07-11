

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:swaminarayancounter/Utility/api_url.dart';
import 'package:swaminarayancounter/Utility/shared_preferences.dart';
import 'package:swaminarayancounter/custom_videoPlayer/SingleVideoPlayerItem.dart';
import 'package:swaminarayancounter/main.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';

class GanpatiStatus extends StatefulWidget {
  const GanpatiStatus({Key? key}) : super(key: key);

  @override
  _GanpatiStatusState createState() => _GanpatiStatusState();
}

class _GanpatiStatusState extends State<GanpatiStatus> {
  List statusUrl = [];
  void fetchUrl() async {
    try {
      var response = await http.get(Uri.parse(AppUrl.ganpatiStatusApi),headers: {
        "Accept": "application/json",
        "Access-Control_Allow_Origin": "*"
      });
      setState(() {
        List newData = [];
        List data = jsonDecode(response.body);
        String? lastId = prefs.getString(ganpatiStatusLastIdKey);
        if(lastId == null) {
          statusUrl = data;
        }else{
          for(int i = 0; i  < data.length; i++) {
            if(int.parse(data[i]['id']) >= int.parse(lastId)){
              newData.add(data[i]);
            }
          }

          for(int i = 0; i  < data.length; i++) {
            if(int.parse(data[i]['id']) < int.parse(lastId)){
              newData.add(data[i]);
            }
          }
          statusUrl = newData;
        }
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
        extendBody: true, body: statusUrl.isNotEmpty ? GanpatiStatusBody(statusUrl: statusUrl) : const Center(child:  CircularProgressIndicator()));
  }
}


class GanpatiStatusBody extends StatefulWidget {
  final Controller? testingController;
  final List statusUrl;
  const GanpatiStatusBody({
    Key? key,
    required this.statusUrl,
    this.testingController,
  }) : super(key: key);

  @override
  _GanpatiStatusBodyState createState() => _GanpatiStatusBodyState();
}

class _GanpatiStatusBodyState extends State<GanpatiStatusBody> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  initState() {
    _tabController =
        TabController(length: widget.statusUrl.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RotatedBox(
        quarterTurns: 1,
        child: TabBarView(
          controller: _tabController,
          children: List.generate(
            widget.statusUrl.length,
                (index) {
              return SingleVideoPlayerItem(url: widget.statusUrl[index]['url'],id: widget.statusUrl[index]['id'],feturesName: "ganpatiStatus",index: index,);
            },
          ),
        ),
      ),
    );
  }
}
