
import 'package:flutter/material.dart';
import 'package:swaminarayancounter/app_drawer.dart';
import 'package:swaminarayancounter/constant.dart';
import 'package:swaminarayancounter/ganpati_status/ganpati_status.dart';
import 'package:swaminarayancounter/hanumanStatus/hanuman_status.dart';
import 'package:swaminarayancounter/mahadev_status/mahadev_status.dart';
import 'package:swaminarayancounter/radhaKrishanaStatus/radha_krishna_status.dart';
import 'package:swaminarayancounter/swaminarayanStatus/swaminarayan_status.dart';

class WhatsAppStatus extends StatelessWidget {
  const WhatsAppStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle =
    const TextStyle(fontSize: fontSize * 1.5, color: Colors.white);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(whatsappStatus),
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
      body: ListView(
        children: [
          const SizedBox(height: customHeight/2),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SwaminarayanStatus()),
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
                        Text(swaminarayanStatus, style: textStyle),
                        const Icon(Icons.check_circle_outline,
                            color: Colors.white)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: customHeight/2),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const HanumanStatus()),
              );
            },
            child: Card(
              color: Colors.deepOrange,
              child: SizedBox(
                height: 100,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(padding*2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(hanumanStatus,style: textStyle),
                        const Icon(Icons.check_circle_outline,color: Colors.white)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: customHeight/2),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MahadevStatus()),
              );
            },
            child: Card(
              color: Colors.deepOrange,
              child: SizedBox(
                height: 100,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(padding*2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(mahadevStatus,style: textStyle),
                        const Icon(Icons.check_circle_outline,color: Colors.white)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: customHeight/2),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RadhaKrishnaStatus()),
              );
            },
            child: Card(
              color: Colors.deepOrange,
              child: SizedBox(
                height: 100,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(padding*2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(radhaKrishana,style: textStyle),
                        const Icon(Icons.check_circle_outline,color: Colors.white)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: customHeight/2),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const GanpatiStatus()),
              );
            },
            child: Card(
              color: Colors.deepOrange,
              child: SizedBox(
                height: 100,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(padding*2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(ganpatiStatus,style: textStyle),
                        const Icon(Icons.check_circle_outline,color: Colors.white)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: customHeight/2),
        ],
      ),
    );
  }
}
