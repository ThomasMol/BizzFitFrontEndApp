import 'package:flutter/cupertino.dart';
import 'navigation_bar.dart';
import 'package:flutter/material.dart';
import 'widgets.dart';

class AppleWatch extends StatefulWidget {
  static const title = 'Apple Watch 50% off';
  static const icon = Icon(CupertinoIcons.gift_fill);

  @override
  _AppleWatchState createState() => _AppleWatchState();
}

class _AppleWatchState extends State<AppleWatch>{
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        NavigationBar(),
        CupertinoSliverRefreshControl(
          //onRefresh: _refreshData,
        ),
        SliverSafeArea(
          top: false,
          sliver: SliverList(
         delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Material(
                child: Column(children: [
                    Container(
                    height: 250,
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [Image(image: AssetImage('assets/applewatch.jpg'), height: 150,),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                          child:
                          Text('5000 Pts.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ))),
                      SizedBox(height: 10),
                    ])),),
                    Container(
                      child: Padding(padding: EdgeInsets.fromLTRB(15, 15, 15,15),
                      child: Text('The most beloved smart watch worldwide is almost yours! Get a 50% off-coupon code that you can use when buying the latest Apple Watch series 6 at www.bol.com. '
                          'You can buy the coupon using your earned points. Your unique 50% off-code will be sent to you by email.',

                        style:  TextStyle(color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.normal,),),),
                      height: 430,
                      width: MediaQuery.of(context).size.width,

                    )
                ]));
          },childCount:1),
        ),
        ),

        /* SliverSafeArea(
          top: false,
          sliver: SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 12),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                _listBuilder,
                childCount: _itemsLength,
              ),
            ),
          ),
        ), */
      ],
    );
  }
}