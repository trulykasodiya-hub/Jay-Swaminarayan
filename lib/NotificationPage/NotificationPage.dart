
import 'dart:async';
import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';
import 'package:swaminarayancounter/NotificationPage/NotificationDetailPage.dart';
import 'package:swaminarayancounter/Utility/env.dart';
import 'package:swaminarayancounter/Utility/shared_preferences.dart';
import 'package:swaminarayancounter/main.dart';


class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  var notificationRefreshKey = GlobalKey<RefreshIndicatorState>();
  GlobalKey<ScaffoldState> notificationScaffold = GlobalKey();
  List notificationData = [];

  getNotification() {
    setState(() {
      JaySwaminarayan.newNotification = false;
      notificationData = [];
      notificationData = prefs.getString('notification') != null ? jsonDecode(prefs.getString('notification')!) : [];
    });
  }

  /// * Page Refresh * ///
  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 0, milliseconds: 500));
    notificationRefreshKey.currentState?.show();
    return getNotification();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: notificationScaffold,
      appBar: AppBar(
        elevation: 1,
        title: const Text("નોટિફિકેશન"),
        actions: [
          TextButton(onPressed: () {
            UserPreferences().removeNotification();
            setState(() {
              notificationData = [];
            });
          }, child: const Icon(Icons.delete))

        ],
      ),
      body: SafeArea(child: notificationData.isNotEmpty ?
      RefreshIndicator(
        onRefresh: _refresh,
        child: ListView.builder(
          itemCount: notificationData.length,
          itemBuilder: (BuildContext context, int i) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => NotificationDetailPage(title: notificationData[i]['title'], body: notificationData[i]['body'], image: notificationData[i]['image'],),
                ));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                            fit: FlexFit.loose,
                            child: Padding(
                                padding:
                                const EdgeInsets.only(left: 11.0),
                                child: Text("${notificationData[i]['title']}",style: const TextStyle(fontSize: 18.0),))),
                        Images(
                          url: notificationData[i]['image'],
                        ),
                      ],
                    ),
                   const SizedBox(height: 5.0),
                    const Divider(),

                  ],
                ),
              ),
            );
          },),
      ) : const Center(child: Text("No Data"))),
    );
  }
}

class Images extends StatelessWidget {
  final String url;
  const Images({required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      width: 100,
      decoration:const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: url == ""
          ? ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset(
          "assets/images/slide03.jpg",
          fit: BoxFit.cover,
        ),
      )
          : ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: CachedNetworkImage(
            placeholder: (context, url) => const SkeletonAvatar(
              style: SkeletonAvatarStyle(
                width: 100.0,
              ),
            ),
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            imageUrl: url),
      ),
    );
  }
}

class NotificationButton extends StatefulWidget {
  const NotificationButton({Key? key}) : super(key: key);

  @override
  _NotificationButtonState createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton> {

  Timer? _timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _timer =  Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      setState(() {
        JaySwaminarayan.newNotification = JaySwaminarayan.newNotification;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Badge(
      position: BadgePosition.topEnd(top: 8, end: 1),
      badgeContent: const Text('new',style: TextStyle(fontSize: 7,color: Colors.white),),
      showBadge: JaySwaminarayan.newNotification,
      animationType: 	BadgeAnimationType.fade,
      child: IconButton(
          icon: const Icon(
            Icons.notifications,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => const NotificationPage(),
            ));
          }),
    ) ;
  }
}
