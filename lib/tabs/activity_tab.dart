import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../navigation_bar.dart';
import '../activities/create_physical_activity_page.dart';
import '../activities/create_mental_state_page.dart';
import '../api.dart';
import '../widgets.dart';

class ActivityTab extends StatefulWidget {
  static const title = 'Activity';
  static const icon = Icon(CupertinoIcons.chart_bar_square_fill);

  @override
  _ActivityTabState createState() => _ActivityTabState();
}

class _ActivityTabState extends State<ActivityTab> {
  Future<List<dynamic>> futurePhysicalAcitivty;
  Future<List<dynamic>> futureMentalState;

  @override
  void initState() {
    super.initState();
    futurePhysicalAcitivty = fetchPhysicalActivities();
    futureMentalState = fetchMentalState();
  }

  @override
  Widget build(BuildContext context) {
    final physicalActivityBuilder = FutureBuilder<List<dynamic>>(
        future: futurePhysicalAcitivty,
        builder: (context, snapshot) {
          Widget newsListSliver;
          if (snapshot.hasData) {
            newsListSliver = SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              return ListTile(
                title: Text(snapshot.data[index]['type'].toString()),
                subtitle: Text(snapshot.data[index]['time_seconds'].toString()),
                trailing: Text(snapshot.data[index]['date_time'].toString()),
              );
            }, childCount: snapshot.data.length));
          } else {
            newsListSliver = SliverToBoxAdapter(
              child: CupertinoActivityIndicator(),
            );
          }
          return newsListSliver;         
        });
  final mentalStateBuilder = FutureBuilder<List<dynamic>>(
        future: futureMentalState,
        builder: (context, snapshot) {
          Widget newsListSliver;
          if (snapshot.hasData) {
            newsListSliver = SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              return ListTile(
                title: Text(snapshot.data[index]['state'].toString()),
                trailing: Text(snapshot.data[index]['date_time'].toString()),
              );
            }, childCount: snapshot.data.length));
          } else {
            newsListSliver = SliverToBoxAdapter(
              child: CupertinoActivityIndicator(),
            );
          }
          return newsListSliver;         
        });

    return SafeArea(
        child: Scaffold(
      body: CustomScrollView(
        slivers: [
          NavigationBar(),
          CupertinoSliverRefreshControl(onRefresh: () async {
            reloadData();
          }),
          physicalActivityBuilder,
          mentalStateBuilder
        ],
      ),
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
                            Navigator.of(context, rootNavigator: true)
                                .push<void>(
                              CupertinoPageRoute(
                                title: CreatePhysicalActivity.title,
                                fullscreenDialog: true,
                                builder: (context) => CreatePhysicalActivity(),
                              ),
                            );
                          }),
                      CupertinoActionSheetAction(
                        child: const Text('Add mental state'),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.of(context, rootNavigator: true).push<void>(
                            CupertinoPageRoute(
                              title: CreateMentalState.title,
                              fullscreenDialog: true,
                              builder: (context) => CreateMentalState(),
                            ),
                          );
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

  void reloadData() {
    setState(() {
      futurePhysicalAcitivty = fetchPhysicalActivities();
      futureMentalState = fetchMentalState();
    });
  }

  Future<List<dynamic>> fetchPhysicalActivities() async {
    var response = await CallApi().getRequest(null, '/physicalactivities');
    if (response['status'] == 'Success') {
      return response['data'];
    } else if (response['status'] == 'Error') {
      // TODO Handle status is error

    } else {
      // Handle when there is no error or no success (probably when server is not online or something)
    }
  }
  Future<List<dynamic>> fetchMentalState() async {
    var response = await CallApi().getRequest(null, '/mentalstates');
    if (response['status'] == 'Success') {
      return response['data'];
    } else if (response['status'] == 'Error') {
      //TODO Handle status is error

    } else {
      // Handle when there is no error or no success (probably when server is not online or something)
    }
  }
}
