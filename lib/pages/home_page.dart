import 'package:bizzfit/pages/profile_page.dart';
import 'package:bizzfit/tabs/mood_tab.dart';
import 'package:bizzfit/tabs/physical_activity_tab.dart';
import 'package:flutter/cupertino.dart';
import '../tabs/insights_tab.dart';
import '../tabs/ranking_tab.dart';
import '../tabs/feed_tab.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.permissionLevel}) : super(key: key);
  final int permissionLevel;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _title;

  final List<StatefulWidget> _widgetOptions = [
    FeedTab(),
    RankingTab(),
    PhysicalActivityTab(),
    MoodTab(),
    InsightsTab()
  ];

  @override
  void initState() {
    super.initState();
    _title = FeedTab.title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(_title),
          ),
          actions: <Widget>[
            IconButton(
              iconSize: 30,
              padding: EdgeInsets.all(14),
              color: Colors.orangeAccent,
              icon: const Icon(Icons.account_circle),
              tooltip: 'View profile',
              onPressed: openProfile,
            ),
          ],
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: FeedTab.title,
              icon: FeedTab.icon,
            ),
            BottomNavigationBarItem(
              label: RankingTab.title,
              icon: RankingTab.icon,
            ),
            BottomNavigationBarItem(
              label: PhysicalActivityTab.title,
              icon: PhysicalActivityTab.icon,
            ),
            BottomNavigationBarItem(
              label: MoodTab.title,
              icon: MoodTab.icon,
            ),
            if (widget.permissionLevel == 1)
              BottomNavigationBarItem(
                label: InsightsTab.title,
                icon: InsightsTab.icon,
              ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
          selectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
        ));
  }

  Widget pageAdmin = CupertinoTabScaffold(
    tabBar: CupertinoTabBar(
      activeColor: CupertinoColors.activeOrange,
      items: [
        BottomNavigationBarItem(
          label: FeedTab.title,
          icon: FeedTab.icon,
        ),
        BottomNavigationBarItem(
          label: RankingTab.title,
          icon: RankingTab.icon,
        ),
        BottomNavigationBarItem(
          label: PhysicalActivityTab.title,
          icon: PhysicalActivityTab.icon,
        ),
        BottomNavigationBarItem(
          label: MoodTab.title,
          icon: MoodTab.icon,
        ),
        BottomNavigationBarItem(
          label: InsightsTab.title,
          icon: InsightsTab.icon,
        ),
        /* BottomNavigationBarItem(
          label: ShopTab.title,
          icon: ShopTab.icon,
        ), */
      ],
    ),
    tabBuilder: (context, index) {
      switch (index) {
        case 0:
          return CupertinoTabView(
            defaultTitle: FeedTab.title,
            builder: (context) => FeedTab(),
          );
        case 1:
          return CupertinoTabView(
            defaultTitle: RankingTab.title,
            builder: (context) => RankingTab(),
          );
        case 2:
          return CupertinoTabView(
            defaultTitle: PhysicalActivityTab.title,
            builder: (context) => PhysicalActivityTab(),
          );
        case 3:
          return CupertinoTabView(
            defaultTitle: MoodTab.title,
            builder: (context) => MoodTab(),
          );
        case 4:
          return CupertinoTabView(
            defaultTitle: InsightsTab.title,
            builder: (context) => InsightsTab(),
          );
        /* case 4:
          return CupertinoTabView(
            defaultTitle: ShopTab.title,
            builder: (context) => ShopTab(),
          ); */

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
          label: FeedTab.title,
          icon: FeedTab.icon,
        ),
        BottomNavigationBarItem(
          label: RankingTab.title,
          icon: RankingTab.icon,
        ),
        BottomNavigationBarItem(
          label: PhysicalActivityTab.title,
          icon: PhysicalActivityTab.icon,
        ),
        BottomNavigationBarItem(
          label: MoodTab.title,
          icon: MoodTab.icon,
        ),
        /*  BottomNavigationBarItem(
          label: ShopTab.title,
          icon: ShopTab.icon,
        ), */
      ],
    ),
    tabBuilder: (context, index) {
      switch (index) {
        case 0:
          return CupertinoTabView(
            defaultTitle: FeedTab.title,
            builder: (context) => FeedTab(),
          );
        case 1:
          return CupertinoTabView(
            defaultTitle: RankingTab.title,
            builder: (context) => RankingTab(),
          );
        case 2:
          return CupertinoTabView(
            defaultTitle: PhysicalActivityTab.title,
            builder: (context) => PhysicalActivityTab(),
          );
        case 3:
          return CupertinoTabView(
            defaultTitle: MoodTab.title,
            builder: (context) => MoodTab(),
          );
        /*  case 3:
          return CupertinoTabView(
            defaultTitle: ShopTab.title,
            builder: (context) => ShopTab(),
          ); */

        default:
          assert(false, 'Unexpected tab');
          return SizedBox.shrink();
      }
    },
  );

  void openProfile() {
    Navigator.of(context, rootNavigator: true).push<void>(
      CupertinoPageRoute(
        title: Profile.title,
        fullscreenDialog: true,
        builder: (context) => Profile(),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          _title = FeedTab.title;
          break;
        case 1:
          _title = RankingTab.title;
          break;
        case 2:
          _title = PhysicalActivityTab.title;
          break;
        case 3:
          _title = MoodTab.title;
          break;
        case 4:
          _title = InsightsTab.title;
          break;
      }
    });
  }
}
