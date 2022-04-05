import 'package:flutter/material.dart';
import 'package:swaminarayancounter/app_drawer.dart';
import 'package:swaminarayancounter/constant.dart';
import 'package:swaminarayancounter/janmangalNamavali/janmangal_namavali_list.dart';

class JanmangalNamavali extends StatefulWidget {
  const JanmangalNamavali({Key? key}) : super(key: key);

  @override
  _JanmangalNamavaliState createState() => _JanmangalNamavaliState();
}

class _JanmangalNamavaliState extends State<JanmangalNamavali> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(janmangalNamavali),
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
            itemCount: janmangalNamavaliData.length,
            itemBuilder: (context, i) {
              return Card(
                  child: ListTile(
                leading: Text(
                  "${i + 1}",
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                title: Padding(
                  padding: const EdgeInsets.symmetric(vertical: padding / 2),
                  child: Text(
                    janmangalNamavaliData[i],
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold),
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
