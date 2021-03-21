import 'package:flutter/cupertino.dart';
import '../navigation_bar.dart';

class ShopTab extends StatefulWidget {
  static const title = 'Shop';
  static const icon = Icon(CupertinoIcons.cart_fill);

  @override
  _ShopTabState createState() => _ShopTabState();
}

class _ShopTabState extends State<ShopTab>{
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