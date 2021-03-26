import 'package:flutter/cupertino.dart';
import '../navigation_bar.dart';
import '../widgets.dart';


class SocialTab extends StatefulWidget {
  static const title = 'Social';
  static const icon = Icon(CupertinoIcons.person_2_fill);

  @override
  _SocialTabState createState() => _SocialTabState();
}

class _SocialTabState extends State<SocialTab> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        NavigationBar(),
        CupertinoSliverRefreshControl(
           // onRefresh: CustomWidgets.showMessage(context,'test'),
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


