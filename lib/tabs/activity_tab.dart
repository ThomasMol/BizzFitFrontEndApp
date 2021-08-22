import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/navigation_bar.dart';
import '../activities/create_physical_activity_page.dart';
import '../pages/create_mental_state_page.dart';
import '../api.dart';
import 'package:intl/intl.dart';

// Not used anymore, moods and physical activity are now seperate tab
class ActivityTab extends StatefulWidget {
  static const title = 'Activity';
  static const icon = Icon(CupertinoIcons.chart_bar_square_fill);

  @override
  _ActivityTabState createState() => _ActivityTabState();
}

class _ActivityTabState extends State<ActivityTab> {
  Future<List<dynamic>> futureActivityWeek;

  List<Icon> moodIcons = [
    Icon(Icons.sentiment_very_dissatisfied, color: Colors.deepOrange, size: 42),
    Icon(Icons.sentiment_dissatisfied, color: Colors.orange, size: 42),
    Icon(Icons.sentiment_neutral, color: Colors.blueGrey, size: 42),
    Icon(Icons.sentiment_satisfied, color: Colors.green, size: 42),
    Icon(Icons.sentiment_very_satisfied, color: Colors.lightGreen, size: 42)
  ];
  List<String> moods = ['Awful', 'Bad', 'Neutral', 'Good', 'Amazing'];

  List<String> weekDates;
  List<String> weekDatesDisplay;

  @override
  void initState() {
    super.initState();

    futureActivityWeek = fetchActivitiesWeek();

    weekDates = generateListDates('yyyy-MM-dd', 5);
    weekDatesDisplay = generateListDates('E d MMMM', 5);
  }

  @override
  Widget build(BuildContext context) {
    final activityWeekBuilder = FutureBuilder<List<dynamic>>(
        future: futureActivityWeek,
        builder: (context, snapshot) {
          Widget newsListSliver;
          if (snapshot.hasData) {
            newsListSliver = SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              Widget mentalStateList;
              Widget physicalActivityList;
              Widget dateDisplay;
              if (snapshot.data[0].length > 0) {
                if (snapshot.data[0][weekDates[index]] != null) {
                  mentalStateList = ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data[0][weekDates[index]].length,
                      itemBuilder: (BuildContext context, int listViewIndex) {
                        var data =
                            snapshot.data[0][weekDates[index]][listViewIndex];
                        DateTime dateTime = DateTime.parse(data['date_time']);
                        String time = DateFormat('H:mm').format(dateTime);
                        return ListTile(
                            leading: moodIcons[data['state']],
                            title: Text(moods[data['state']]),
                            subtitle: Text('Your mood'),
                            trailing: Text(time));
                      });
                } else {
                  mentalStateList =
                      ListTile(subtitle: Text('No mood data for this day'));
                }
              } else {
                mentalStateList =
                    ListTile(subtitle: Text('No mood data for this day'));
              }

              if (snapshot.data[1].length > 0) {
                if (snapshot.data[1][weekDates[index]] != null &&
                    snapshot.data[1].length > 0) {
                  physicalActivityList = ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data[1][weekDates[index]].length,
                      itemBuilder: (BuildContext context, int listViewIndex) {
                        var data =
                            snapshot.data[1][weekDates[index]][listViewIndex];
                        Duration activityTime =
                            Duration(seconds: data['time_seconds']);
                        DateTime dateTime = DateTime.parse(data['date_time']);
                        String time = DateFormat('H:mm').format(dateTime);
                        return ListTile(
                            title: Text(data['type']),
                            subtitle: Text("Time spent: " +
                                activityTime
                                    .toString()
                                    .split('.')
                                    .first
                                    .padLeft(8, "0")),
                            trailing: Text(time));
                      });
                } else {
                  physicalActivityList = ListTile(
                      subtitle: Text('No physical activity data for this day'));
                }
              } else {
                physicalActivityList = ListTile(
                    subtitle: Text('No physical activity data for this day'));
              }

              dateDisplay = ListTile(
                leading: Text(weekDatesDisplay[index]),
                trailing: Icon(CupertinoIcons.time),
              );

              return Card(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      dateDisplay,
                      const Divider(
                        height: 1,
                      ),
                      mentalStateList,
                      const Divider(
                        height: 1,
                      ),
                      physicalActivityList
                    ],
                  ));
            }, childCount: weekDates.length));
          } else {
            newsListSliver = SliverToBoxAdapter(
              child: ListTile(
                title: Text("No data for today!"),
              ),
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
          activityWeekBuilder
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
      futureActivityWeek = fetchActivitiesWeek();
      weekDates = generateListDates('yyyy-MM-dd', 5);
      weekDatesDisplay = generateListDates('E d MMMM', 5);
    });
  }

  List<String> generateListDates(String format, int length) {
    return List<String>.generate(length, (i) {
      DateTime dateTime = DateTime.utc(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ).subtract(Duration(days: i));
      String formattedDateTime = DateFormat(format).format(dateTime);
      return formattedDateTime;
    });
  }

  Future<List<dynamic>> fetchActivitiesWeek() async {
    var response = await CallApi().getRequest(null, '/activities/week');
    if (response['status'] == 'Success') {
      return response['data'];
    } else {
      return response['message'];
    }
  }
}
