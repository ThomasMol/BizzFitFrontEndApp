import 'package:flutter/cupertino.dart';
import 'profile_page.dart';

class NavigationBar extends StatelessWidget {
  const NavigationBar({
    Key key,
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
}
