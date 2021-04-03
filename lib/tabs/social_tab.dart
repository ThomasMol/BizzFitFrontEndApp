import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../navigation_bar.dart';
import '../widgets.dart';

class SocialTab extends StatefulWidget {
  static const title = 'Social';
  static const icon = Icon(CupertinoIcons.person_2_fill);

  @override
  _SocialTabState createState() => _SocialTabState();
}

class _SocialTabState extends State<SocialTab> {
  TextEditingController _textController;

  Widget sideScrollCard(AssetImage image, String title, String subtitle) {
    return Card(
        elevation: 2,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Column(children: [
          Image(
            image: image,
            height: 100,
          ),
          SizedBox(height: 15),
          Text(
            title,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 5),
          Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.black54))
        ]),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 30));
  }

  Widget fullImageCard(AssetImage image, String title, String subtitle) {
    return Card(
        elevation: 2,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Stack(children: [
          Image(
            image: image,
            width: MediaQuery.of(context).size.width,
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(20, 170, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold))
                ],
              ))
        ]),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20));
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        NavigationBar(),
        CupertinoSliverRefreshControl(
            // onRefresh: CustomWidgets.showMessage(context,'test'),
            ),
        SliverSafeArea(
          top: false,
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Material(
                    child: Column(children: [
                  Container(
                      height: 215,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          CupertinoColors.activeOrange,
                          CupertinoColors.activeOrange.withAlpha(70),
                        ],
                      )),
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Discover Activities',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    )),
                                SizedBox(height: 60),
                                TextField(
                                  autofocus: false,
                                  maxLength: 30,
                                  cursorColor: Colors.black38,
                                  decoration: InputDecoration(
                                      hintText: 'Search activities',
                                      suffixStyle: TextStyle(
                                          color: CupertinoColors.activeBlue),
                                      focusedBorder: InputBorder.none,
                                      filled: true,
                                      fillColor: Colors.white,
                                      suffixIcon: Icon(CupertinoIcons.search)),
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 20,
                                  ),
                                )
                              ]))),
                  SizedBox(height: 30),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Popular near you',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 18)))),
                  Container(
                      height: 230,
                      width: MediaQuery.of(context).size.width,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          sideScrollCard(AssetImage('assets/running.jpg'),
                              "Running", 'Beach run'),
                          sideScrollCard(AssetImage('assets/hiking.jpg'),
                              "Hiking", 'Veluwe'),
                          sideScrollCard(
                              AssetImage('assets/yoga.jpg'), "Yoga", 'At home')
                        ],
                      )),
                  SizedBox(height: 20),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Featured Activities',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 18)))),
                  fullImageCard(AssetImage('assets/yoga_2.jpg'), "Yoga", 'Beginner level'),
                  fullImageCard(AssetImage('assets/meditation.jpg'), "Meditation", 'Low intensity'),
                  fullImageCard(AssetImage('assets/weightlifting.jpg'), "Weightlifting", 'High intensity'),
                ]));
              },
              childCount: 1,
            ),
          ),
        ),
      ],
    );
  }
}
