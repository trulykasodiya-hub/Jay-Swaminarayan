import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swaminarayancounter/Utility/shared_preferences.dart';
import 'package:swaminarayancounter/constant.dart';
import 'package:swaminarayancounter/main.dart';

import '../app_drawer.dart';

class ViewMantraJap extends StatefulWidget {
  final int mantraJapCount;
  const ViewMantraJap({Key? key, required this.mantraJapCount})
      : super(key: key);

  @override
  _ViewMantraJapState createState() => _ViewMantraJapState();
}

class _ViewMantraJapState extends State<ViewMantraJap> {
  List totalMantraJap = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      if (prefs.getString(mantraJapKey) != null) {
        dynamic data = prefs.getString(mantraJapKey);
        dynamic decodeData = jsonDecode(data);
        totalMantraJap = decodeData;
      } else {
        totalMantraJap = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(mantraJap),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context, widget.mantraJapCount);
              },
              icon: const Icon(Icons.home)),
          const SizedBox(width: customWidth)
        ],
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
          child: totalMantraJap.isNotEmpty
              ? ListView.builder(
                  itemCount: totalMantraJap.length,
                  itemBuilder: (context, i) {
                    return Card(
                        child: ListTile(
                      title: Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: padding / 2),
                        child: Text(
                          "તમારો મંત્રજાપ : ${totalMantraJap[i]['count']}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      subtitle: Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: padding / 2),
                        child: Text(
                          "મંત્રજાપ સેવ કરેલ તારીખ : " +
                              DateFormat.yMd().format(DateTime.parse(
                                  "${totalMantraJap[i]['date']}")),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              totalMantraJap.removeAt(i);
                              UserPreferences()
                                  .saveMantraJap(jsonEncode(totalMantraJap));
                            });
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          )),
                    ));
                  })
              : const Center(
                  child: Text(noData),
                )),
    );
  }
}
