import 'package:flutter/cupertino.dart';

import 'tabs/activity_tab.dart';
import 'tabs/insights_tab.dart';
import 'tabs/ranking_tab.dart';
import 'tabs/shop_tab.dart';
import 'tabs/social_tab.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
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
  }
}
