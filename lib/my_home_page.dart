import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:swaminarayancounter/app_drawer.dart';
import 'package:swaminarayancounter/constant.dart';
import 'package:swaminarayancounter/MantraJap/mantra_jap.dart';
import 'package:swaminarayancounter/janmangalNamavali/janmangal_namavali.dart';
import 'package:swaminarayancounter/liveDarshan/live_darshan.dart';
import 'package:swaminarayancounter/sikshapatri/sikshapatri.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AppUpdateInfo? _updateInfo;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });
    }).catchError((e) {
      showSnack(e.toString());
    });
  }

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _updateInfo?.updateAvailability == UpdateAvailability.updateAvailable
        ? () {
            InAppUpdate.performImmediateUpdate().catchError((e) {
              showSnack(e.toString());
            });
          }
        : null;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle =
        const TextStyle(fontSize: fontSize * 1.5, color: Colors.white);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(widget.title),
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(padding),
        child: Center(
          child: ListView(
            children: <Widget>[
              const SizedBox(height: customHeight),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LiveDarshan()),
                  );
                },
                child: Card(
                  color: Colors.deepOrange,
                  child: SizedBox(
                    height: 100,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(padding * 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(liveDarshan, style: textStyle),
                            const Icon(Icons.check_circle_outline,
                                color: Colors.white)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: customHeight / 2),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MantraJap()),
                  );
                },
                child: Card(
                  color: Colors.deepOrange,
                  child: SizedBox(
                    height: 100,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(padding * 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(mantraJap, style: textStyle),
                            const Icon(Icons.check_circle_outline,
                                color: Colors.white)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: customHeight / 2),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const JanmangalNamavaliPage()),
                  );
                },
                child: Card(
                  color: Colors.deepOrange,
                  child: SizedBox(
                    height: 100,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(padding * 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(janmangalNamavali, style: textStyle),
                            const Icon(Icons.check_circle_outline,
                                color: Colors.white)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: customHeight / 2),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Sikshapatri()),
                  );
                },
                child: Card(
                  color: Colors.deepOrange,
                  child: SizedBox(
                    height: 100,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(padding * 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(sikshapatri, style: textStyle),
                            const Icon(Icons.check_circle_outline,
                                color: Colors.white)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // const SizedBox(height: customHeight/2),
              // Card(
              //   color: Colors.deepOrange,
              //   child: SizedBox(
              //     height: 100,
              //     child: Center(
              //       child: Padding(
              //         padding: const EdgeInsets.all(padding*2),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text(nityaNiyam,style: textStyle),
              //             const Icon(Icons.check_circle_outline,color: Colors.white)
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              //
              // const SizedBox(height: customHeight/2),
              // InkWell(
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => const SwaminarayanDhun()),
              //     );
              //   },
              //   child: Card(
              //     color: Colors.deepOrange,
              //     child: SizedBox(
              //       height: 100,
              //       child: Center(
              //         child: Padding(
              //           padding: const EdgeInsets.all(padding*2),
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               Text(swaminarayanDhun,style: textStyle),
              //               const Icon(Icons.check_circle_outline,color: Colors.white)
              //             ],
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: customHeight/2),
              // Card(
              //   color: Colors.deepOrange,
              //   child: SizedBox(
              //     height: 100,
              //     child: Center(
              //       child: Padding(
              //         padding: const EdgeInsets.all(padding*2),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text(swaminarayanRington,style: textStyle),
              //             const Icon(Icons.check_circle_outline,color: Colors.white)
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: customHeight/2),
              // Card(
              //   color: Colors.deepOrange,
              //   child: SizedBox(
              //     height: 100,
              //     child: Center(
              //       child: Padding(
              //         padding: const EdgeInsets.all(padding*2),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text(wallpaper,style: textStyle),
              //             const Icon(Icons.check_circle_outline,color: Colors.white)
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: customHeight/2),
              // Card(
              //   color: Colors.deepOrange,
              //   child: SizedBox(
              //     height: 100,
              //     child: Center(
              //       child: Padding(
              //         padding: const EdgeInsets.all(padding*2),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text(suvichar,style: textStyle),
              //             const Icon(Icons.check_circle_outline,color: Colors.white)
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(height: customHeight * 5),
            ],
          ),
        ),
      ),
      // floatingActionButton: const FloatingActionButton(
      //   onPressed: null,
      //   tooltip: 'Help',
      //   child: Icon(Icons.help),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
