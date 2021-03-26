import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../navigation_bar.dart';
import '../activities/create_physical_activity_page.dart';
import '../api.dart';
import '../widgets.dart';

class ActivityTab extends StatefulWidget {
  static const title = 'Activity';
  static const icon = Icon(CupertinoIcons.sportscourt_fill);

  @override
  _ActivityTabState createState() => _ActivityTabState();
}

class _ActivityTabState extends State<ActivityTab> {
  Future<List<dynamic>> futurePhysicalAcitivty;
  @override
  void initState() {
    super.initState();
    futurePhysicalAcitivty = fetchPhysicalActivities();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: FutureBuilder<List<dynamic>>(
          future: futurePhysicalAcitivty,
          builder: (context, snapshot) {
            Widget newsListSliver;
            if (snapshot.hasData) {
              newsListSliver = SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(snapshot.data[index]['type'].toString()),
                      subtitle:
                          Text(snapshot.data[index]['time_seconds'].toString()),
                      trailing:
                          Text(snapshot.data[index]['date_time'].toString()),
                    )
                  ],
                );
              }, childCount: snapshot.data.length));
            } else {
              newsListSliver = SliverToBoxAdapter(
                child: CircularProgressIndicator(),
              );
            }
            return CustomScrollView(
              slivers: [NavigationBar(), newsListSliver],
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) => CupertinoActionSheet(
                    title: const Text('Choose the type of activity'),
                    cancelButton: CupertinoActionSheetAction(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    actions: [
                      CupertinoActionSheetAction(
                          child: const Text('Add physical activity'),
                          onPressed: () {
                            Navigator.pop(context);
                            _openAddNewActivityPage();
                          }),
                      CupertinoActionSheetAction(
                        child: const Text('Add mental state'),
                        onPressed: () {
                          CustomWidgets.showMessage('test', context);
                        },
                      )
                    ],
                  ));
        },
        elevation: 4,
        child: const Icon(CupertinoIcons.add),
        backgroundColor: CupertinoColors.activeOrange,
      ),
    ));
  }

  void _openAddNewActivityPage() {
    Navigator.of(context, rootNavigator: true).push<void>(
      CupertinoPageRoute(
        title: CreatePhysicalActivity.title,
        fullscreenDialog: true,
        builder: (context) => CreatePhysicalActivity(),
      ),
    );
  }

  Future<List<dynamic>> fetchPhysicalActivities() async {
    var response = await CallApi().getRequest(null, '/physicalactivities');
    if (response['status'] == 'Success') {
      return response['data'];
    } else if (response['status'] == 'Error') {
      //TODO Handle status is error

    } else {
      // Handle when there is no error or no success (probably when server is not online or something)
    }
  }
}
