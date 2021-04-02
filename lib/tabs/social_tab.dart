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
                  Container(child: Text('test')),
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
