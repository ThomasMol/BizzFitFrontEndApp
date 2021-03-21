import 'package:flutter/cupertino.dart';
import '../navigation_bar.dart';

class InsightsTab extends StatefulWidget {
  static const title = 'Insights';
  static const icon = Icon(CupertinoIcons.chart_pie_fill);

  @override
  _InsightsTabState createState() => _InsightsTabState();
}

class _InsightsTabState extends State<InsightsTab>{
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