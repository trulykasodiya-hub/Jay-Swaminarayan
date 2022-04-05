import 'package:flutter/material.dart';
import 'package:swaminarayancounter/constant.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(icon: Icons.check_circle, text: liveDarshan),
          _createDrawerItem(icon: Icons.check_circle, text: mantraJap),
          _createDrawerItem(icon: Icons.check_circle, text: janmangalNamavali),
          _createDrawerItem(icon: Icons.check_circle, text: sikshapatri),
          // Divider(),
          // _createDrawerItem(icon: Icons.collections_bookmark, text:           'Steps'),
          // _createDrawerItem(icon: Icons.face, text: 'Authors'),
          // _createDrawerItem(icon: Icons.account_box, text: 'Flutter Documentation'),
          // _createDrawerItem(icon: Icons.stars, text: 'Useful Links'),
          const Divider(),
          _createDrawerItem(icon: Icons.bug_report, text: 'Report an issue'),
          ListTile(
            title: const Text('2.1.1'),
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
