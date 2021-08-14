import 'package:bizzfit/api.dart';
import 'package:bizzfit/utils.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/navigation_bar.dart';
import 'package:flutter/material.dart';
import '../pages/applewatch_page.dart';

class ShopTab extends StatefulWidget {
  static const title = 'Shop';
  static const icon = Icon(CupertinoIcons.gift_fill);

  @override
  _ShopTabState createState() => _ShopTabState();
}

class _ShopTabState extends State<ShopTab> {
  Future<dynamic> futureProfile;
  @override
  void initState() {
    super.initState();
    futureProfile = fetchProfile();
  }

  // horizontal sliding scrollcard widget
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
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(height: 5),
          Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.black54))
        ]),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 30));
  }

  @override
  Widget build(BuildContext context) {
    final builderShop = FutureBuilder<dynamic>(
        future: futureProfile,
        builder: (context, snapshot) {
          Widget newsListSliver;
          if (snapshot.hasData) {
            newsListSliver = SliverList(
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
                                  Text(
                                      'Your Credit: ${snapshot.data['score'].toString()} Points',
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
                                        hintText: 'Search the shop',
                                        suffixStyle: TextStyle(
                                            color: CupertinoColors.activeBlue),
                                        focusedBorder: InputBorder.none,
                                        filled: true,
                                        fillColor: Colors.white,
                                        suffixIcon:
                                            Icon(CupertinoIcons.search)),
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
                            child: Text('Popular rewards',
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 18)))),
                    Container(
                        height: 230,
                        width: MediaQuery.of(context).size.width,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .push<void>(
                                  CupertinoPageRoute(
                                    title: AppleWatch.title,
                                    fullscreenDialog: true,
                                    builder: (context) => AppleWatch(),
                                  ),
                                );
                              },
                              child: sideScrollCard(
                                  AssetImage('assets/applewatch.jpg'),
                                  "Apple Watch 50% off",
                                  '5000 Pts.'),
                            ),
                            sideScrollCard(AssetImage('assets/dumbbells.jpg'),
                                "Dumbbells 1KG", '100 Pts.'),
                            sideScrollCard(AssetImage('assets/yoga.jpg'),
                                "Yoga Class", '250 Pts.')
                          ],
                        )),
                    Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Workshops',
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 18)))),
                    Container(
                        height: 230,
                        width: MediaQuery.of(context).size.width,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            sideScrollCard(AssetImage('assets/mtb.jpg'),
                                "Mountainbike Clinic", '350 Pts.'),
                            sideScrollCard(AssetImage('assets/yoga.jpg'),
                                "Yoga Class", '250 Pts.'),
                            sideScrollCard(AssetImage('assets/mindfulness.jpg'),
                                "Mindfulness Coaching", '400 Pts.')
                          ],
                        )),
                    Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Products',
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 18)))),
                    Container(
                        height: 230,
                        width: MediaQuery.of(context).size.width,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            sideScrollCard(AssetImage('assets/fitbit.jpg'),
                                "Fitbit Charge 3 50% Off", '2000 Pts.'),
                            sideScrollCard(AssetImage('assets/yoga_mat.jpg'),
                                "Yoga Mat", '300 Pts.'),
                            sideScrollCard(AssetImage('assets/hello_fresh.jpg'),
                                "Hello Fresh Box", '400 Pts.'),
                            sideScrollCard(AssetImage('assets/applewatch.jpg'),
                                "Apple Watch 50% off", '5000 Pts.')
                          ],
                        )),

                    /*SizedBox(height: 20),
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
                      fullImageCard(AssetImage('assets/weightlifting.jpg'), "Weightlifting", 'High intensity'),*/
                  ]));
                },
                childCount: 1,
              ),
            );
          } else {
            newsListSliver = SliverToBoxAdapter(
                child: Center(
              child: CupertinoActivityIndicator(),
            ));
          }
          return newsListSliver;
        });
    return CustomScrollView(
      slivers: [
        NavigationBar(),
        CupertinoSliverRefreshControl(onRefresh: () async {
          reloadData();
        }),
        SliverSafeArea(
          top: false,
          sliver: builderShop,
        ),
      ],
    );
  }

  Future<dynamic> fetchProfile() async {
    var response = await CallApi().getRequest(null, '/user');
    if (response['status'] == 'Success') {
      return response['data'];
    } else if (response['status'] == 'Error') {
      Utils.showMessage(response['message'], context);
    }
  }

  void reloadData() {
    setState(() {
      futureProfile = fetchProfile();
    });
  }
}
