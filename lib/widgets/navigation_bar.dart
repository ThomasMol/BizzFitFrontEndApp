import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../pages/profile_page.dart';

// Not used anymore

class NavigationBar extends StatelessWidget {
  const NavigationBar({
    Key key,
    String title,
  }) : super(key: key); 

  @override
  Widget build(BuildContext context) {
    void openProfile() {
      Navigator.of(context, rootNavigator: true).push<void>(
        CupertinoPageRoute(
          title: Profile.title,
          fullscreenDialog: true,
          builder: (context) => Profile(),
        ),
      );
    }

    return AppBar(     
      backgroundColor: Colors.white,
      flexibleSpace: const FlexibleSpaceBar(
        title: Text('test'),
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
    );
  }
}
  // Old navigation bar with iOS styling
 /*  @override
  Widget build(BuildContext context) {
    void openProfile() {
      Navigator.of(context, rootNavigator: true).push<void>(
        CupertinoPageRoute(
          title: Profile.title,
          fullscreenDialog: true,
          builder: (context) => Profile(),
        ),
      );
    }

    return CupertinoSliverNavigationBar(
      trailing: CupertinoButton(
        padding: EdgeInsets.zero,
        child: Icon(
          CupertinoIcons.profile_circled,
          color: CupertinoColors.activeOrange,
        ),
        onPressed: openProfile,
      ),
    );
  }
} */
