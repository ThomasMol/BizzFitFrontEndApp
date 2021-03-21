import 'package:flutter/cupertino.dart';
import '../navigation_bar.dart';

class ActivityTab extends StatefulWidget {
  static const title = 'Activity';
  static const icon = Icon(CupertinoIcons.sportscourt_fill);

  @override
  _ActivityTabState createState() => _ActivityTabState();
}

class _ActivityTabState extends State<ActivityTab>{
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
