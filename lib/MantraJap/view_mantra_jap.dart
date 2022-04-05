import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swaminarayancounter/Utility/shared_preferences.dart';
import 'package:swaminarayancounter/constant.dart';
import 'package:swaminarayancounter/main.dart';
import 'package:swaminarayancounter/model/mantraJap_Model.dart';

import '../Controller/database_helper.dart';
import '../app_drawer.dart';

class ViewMantraJap extends StatefulWidget {
  final int mantraJapCount;
  const ViewMantraJap({Key? key, required this.mantraJapCount})
      : super(key: key);

  @override
  _ViewMantraJapState createState() => _ViewMantraJapState();
}

class _ViewMantraJapState extends State<ViewMantraJap> {

  // Database
  final dbHelper = DatabaseHelper.instance;
  List<MantraJapModel> totalMantraJap = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _queryAll();
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
              ? RefreshIndicator(
            onRefresh: _refreshData,
                child: ListView.builder(
                    itemCount: totalMantraJap.length,
                    itemBuilder: (context, i) {
                      return Card(
                          child: ListTile(
                        title: Padding(
                          padding:
                              const EdgeInsets.symmetric(vertical: padding / 2),
                          child: Text(
                            "તમારો મંત્રજાપ : ${totalMantraJap[i].count}",
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
                                    "${totalMantraJap[i].date}")),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                _deleteMantraJap(totalMantraJap[i].id,i);

                              });
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            )),
                      ));
                    }),
              )
              : const Center(
                  child: Text(noData),
                )),
    );
  }

  void _queryAll() async {
    final allRows = await dbHelper.queryAllRows();
    totalMantraJap.clear();
    for (var row in allRows) {
      totalMantraJap.add(MantraJapModel.fromMap(row));
    }
    setState(() {});
  }

  Future<void> _refreshData() async {
     _queryAll();
  }

  Future<void> _deleteMantraJap(id,index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(headerTitle),
          content:
          const Text("શુ તમે તમારા મંત્રજાપ ને કાઢી નાખવા માંગો છો ?"),
          actions: <Widget>[
            TextButton(
              child: const Text('ના'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('હા'),
              onPressed: () async {
                await dbHelper.delete(id);
                setState(() {
                  totalMantraJap.removeAt(index);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
