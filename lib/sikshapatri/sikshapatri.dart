import 'package:flutter/material.dart';
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
                trailing: const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                ),
              ));
            }),
      ),
    );
  }
}
