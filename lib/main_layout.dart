import 'package:bizzfit/authentication/login_page.dart';
import 'package:bizzfit/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'tabs/activity_tab.dart';
import 'tabs/insights_tab.dart';
import 'tabs/ranking_tab.dart';
import 'tabs/shop_tab.dart';
import 'tabs/social_tab.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FlutterSecureStorage storage = FlutterSecureStorage();
  Future<int> permission_level;

  @override
  void initState() {
    super.initState();
    permission_level = checkPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: permission_level,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data > 0) {
              return pageAdmin;
            } else {
              return pageRegular;
            }
          } else {
            return Scaffold(body: Center(child: CupertinoActivityIndicator()));
          }
        });
  }

  Future<int> checkPermissions() async {
    return int.parse(await storage.read(key: 'permission_level'));
  }

  void _logOut() async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    await storage.delete(key: 'access_token');
    await storage.delete(key: 'permission_level');
    Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false);
  }

  Widget pageAdmin = CupertinoTabScaffold(
    tabBar: CupertinoTabBar(
      activeColor: CupertinoColors.activeOrange,
      items: [
        BottomNavigationBarItem(
          label: SocialTab.title,
          icon: SocialTab.icon,
        ),
        BottomNavigationBarItem(
          label: RankingTab.title,
          icon: RankingTab.icon,
        ),
        BottomNavigationBarItem(
          label: ActivityTab.title,
          icon: ActivityTab.icon,
        ),
        BottomNavigationBarItem(
          label: InsightsTab.title,
          icon: InsightsTab.icon,
        ),
        BottomNavigationBarItem(
          label: ShopTab.title,
          icon: ShopTab.icon,
        ),
      ],
    ),
    tabBuilder: (context, index) {
      switch (index) {
        case 0:
          return CupertinoTabView(
            defaultTitle: SocialTab.title,
            builder: (context) => SocialTab(),
          );
        case 1:
          return CupertinoTabView(
            defaultTitle: RankingTab.title,
            builder: (context) => RankingTab(),
          );
        case 2:
          return CupertinoTabView(
            defaultTitle: ActivityTab.title,
            builder: (context) => ActivityTab(),
          );
        case 3:
          return CupertinoTabView(
            defaultTitle: InsightsTab.title,
            builder: (context) => InsightsTab(),
          );
        case 4:
          return CupertinoTabView(
            defaultTitle: ShopTab.title,
            builder: (context) => ShopTab(),
          );

        default:
          assert(false, 'Unexpected tab');
          return SizedBox.shrink();
      }
    },
  );

  Widget pageRegular = CupertinoTabScaffold(
    tabBar: CupertinoTabBar(
      activeColor: CupertinoColors.activeOrange,
      items: [
        BottomNavigationBarItem(
          label: SocialTab.title,
          icon: SocialTab.icon,
        ),
        BottomNavigationBarItem(
          label: RankingTab.title,
          icon: RankingTab.icon,
        ),
        BottomNavigationBarItem(
          label: ActivityTab.title,
          icon: ActivityTab.icon,
        ),
        BottomNavigationBarItem(
          label: ShopTab.title,
          icon: ShopTab.icon,
        ),
      ],
    ),
    tabBuilder: (context, index) {
      switch (index) {
        case 0:
          return CupertinoTabView(
            defaultTitle: SocialTab.title,
            builder: (context) => SocialTab(),
          );
        case 1:
          return CupertinoTabView(
            defaultTitle: RankingTab.title,
            builder: (context) => RankingTab(),
          );
        case 2:
          return CupertinoTabView(
            defaultTitle: ActivityTab.title,
            builder: (context) => ActivityTab(),
          );
        case 3:
          return CupertinoTabView(
            defaultTitle: ShopTab.title,
            builder: (context) => ShopTab(),
          );

        default:
          assert(false, 'Unexpected tab');
          return SizedBox.shrink();
      }
    },
  );
}
