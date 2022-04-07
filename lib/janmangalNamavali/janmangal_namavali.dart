import 'package:flutter/material.dart';
import 'package:swaminarayancounter/app_drawer.dart';
import 'package:swaminarayancounter/constant.dart';
import 'package:swaminarayancounter/janmangalNamavali/janmangal_namavali_list.dart';


class JanmangalNamavaliPage extends StatelessWidget {
  const JanmangalNamavaliPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
          bottom: const TabBar(
            tabs: [
              Tab(child: Text("નામાવલી",style: TextStyle(color: Colors.deepOrange),),),
              Tab(child: Text("સ્ત્રોત",style: TextStyle(color: Colors.deepOrange)),),
            ],
          ),
        ),
        drawer: const AppDrawer(),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            JanmangalNamavali(),
            JanmangalStrot(),
          ],
        ),
      ),
    );
  }
}

class JanmangalStrot extends StatelessWidget {
  const JanmangalStrot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListView.builder(
          itemCount: janmangalNamavaliStrotData.length,
          itemBuilder: (context, i) {
            return Card(
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: padding / 2),
                    child: Text(
                      janmangalNamavaliStrotData[i],
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
    );
  }
}


class JanmangalNamavali extends StatefulWidget {
  const JanmangalNamavali({Key? key}) : super(key: key);

  @override
  _JanmangalNamavaliState createState() => _JanmangalNamavaliState();
}

class _JanmangalNamavaliState extends State<JanmangalNamavali> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
    );
  }
}
