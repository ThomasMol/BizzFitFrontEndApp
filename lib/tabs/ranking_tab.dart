import 'package:flutter/cupertino.dart';
import '../navigation_bar.dart';

class RankingTab extends StatefulWidget {
  static const title = 'Ranking';
  static const icon = Icon(CupertinoIcons.star_fill);

  @override
  _RankingTabState createState() => _RankingTabState();
}

class _RankingTabState extends State<RankingTab>{
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        NavigationBar(),
        CupertinoSliverRefreshControl(
            //onRefresh: _refreshData,
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
