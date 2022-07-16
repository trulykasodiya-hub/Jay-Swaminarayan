import 'package:flutter/material.dart';
import 'package:swaminarayancounter/constant.dart';
import 'package:swaminarayancounter/hanumanStatus/hanuman_status.dart';
import 'package:swaminarayancounter/hanumanchalisa/hanuman_chalisa.dart';
import 'package:swaminarayancounter/hindola_kirtan/hindola_kirtan.dart';
import 'package:swaminarayancounter/janmangalNamavali/janmangal_namavali.dart';
import 'package:swaminarayancounter/kirtan/kirtan.dart';
import 'package:swaminarayancounter/liveDarshan/live_darshan.dart';
import 'package:swaminarayancounter/nitya_niyam/nitya_niyam.dart';
import 'package:swaminarayancounter/prabhatiya/prabhatiya.dart';
import 'package:swaminarayancounter/radhaKrishanaStatus/radha_krishna_status.dart';
import 'package:swaminarayancounter/rington/rington.dart';
import 'package:swaminarayancounter/sikshapatri/sikshapatri.dart';
import 'package:swaminarayancounter/suvichar/suvichar.dart';
import 'package:swaminarayancounter/swaminarayanStatus/swaminarayan_status.dart';
import 'package:swaminarayancounter/swaminarayanWallpaper/swaminarayan_wallpaper.dart';
import 'package:swaminarayancounter/whatsapp_video/whatsapp_video.dart';

import 'MantraJap/mantra_jap.dart';
import 'mahadev_status/mahadev_status.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(
              icon: Icons.check_circle,
              text: liveDarshan,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LiveDarshan()),
                );
              }),
          _createDrawerItem(
              icon: Icons.check_circle,
              text: mantraJap,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MantraJap()),
                );
              }),
          _createDrawerItem(
              icon: Icons.check_circle,
              text: janmangalNamavali,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const JanmangalNamavaliPage()),
                );
              }),
          _createDrawerItem(
              icon: Icons.check_circle,
              text: sikshapatri,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Sikshapatri()),
                );
              }),
          _createDrawerItem(
              icon: Icons.check_circle,
              text: nityaNiyam,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NityaNiyam()),
                );
              }),
          _createDrawerItem(
              icon: Icons.check_circle,
              text: whatsappStatus,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WhatsAppStatus()),
                );
              }),
          _createDrawerItem(
              icon: Icons.check_circle,
              text: hanumanChalisa,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HanumanChalisa()),
                );
              }),
          _createDrawerItem(
              icon: Icons.check_circle,
              text: wallpaper,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SwaminarayanWallpaper()),
                );
              }),
          _createDrawerItem(
              icon: Icons.check_circle,
              text: rington,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Rington()),
                );
              }),
          _createDrawerItem(
              icon: Icons.check_circle,
              text: kirtan,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Kirtan()),
                );
              }),
          _createDrawerItem(
              icon: Icons.check_circle,
              text: prabhatiya,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Prabhatiya()),
                );
              }),
          _createDrawerItem(
              icon: Icons.check_circle,
              text: hindodaKirtan,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HindolaKirtan()),
                );
              }),
          _createDrawerItem(
              icon: Icons.check_circle,
              text: suvichar,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Suvichar()),
                );
              }),
          const Divider(),
          _createDrawerItem(icon: Icons.bug_report, text: 'Report an issue'),
          ListTile(
            title: const Text('App Version : V2.3.4'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/slide03.jpg'))),
        child: Stack(children: const <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text(headerTitle,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500))),
        ]));
  }

  Widget _createDrawerItem(
      {IconData? icon, String? text, GestureTapCallback? onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(text!),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
