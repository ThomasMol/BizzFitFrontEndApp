import 'package:bizzfit/api.dart';
import 'package:bizzfit/navigation_bar.dart';
import 'package:bizzfit/strava/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils.dart';

class PhysicalActivityTab extends StatefulWidget {
  static const title = 'Activities';
  static const icon = Icon(CupertinoIcons.chart_bar_square_fill);

  @override
  _PhysicalActivityTabState createState() => _PhysicalActivityTabState();
}

class _PhysicalActivityTabState extends State<PhysicalActivityTab> {
  Future<List<dynamic>> futureActivityWeek;
  List<String> weekDates;
  List<String> weekDatesDisplay;

  final secureStorage = FlutterSecureStorage();
  bool stravaAuthenticated = false;
  StravaApi stravaApi = StravaApi();

  @override
  void initState() {
    super.initState();
    futureActivityWeek = fetchActivitiesWeek();
    weekDates = Utils.generateListDates('yyyy-MM-dd', 5);
    weekDatesDisplay = Utils.generateListDates('E d MMMM', 5);
    stravaAuthenticated =
        secureStorage.read(key: 'strava_authenticated') != null;
  }

  @override
  Widget build(BuildContext context) {
    final activityBuilder = FutureBuilder<List<dynamic>>(
        future: futureActivityWeek,
        builder: (context, snapshot) {
          Widget activityListWidget;
          if (snapshot.hasData) {
            activityListWidget = SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              return ListTile(
                leading: Icon(Icons.run_circle),
                title: Text(snapshot.data[index]['type']),
                subtitle: Text(snapshot.data[index]['date_time']),
                trailing: Text(snapshot.data[index]['points'].toString()),
              );
            }, childCount: snapshot.data.length));
          } else {
            activityListWidget = SliverToBoxAdapter(
                child: ListTile(
              title: Text('No data'),
            ));
          }

          return activityListWidget;
        });

    return SafeArea(
        child:CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(onRefresh: () async {
            reloadData();
          }),
          activityBuilder
        ],
      ),
    );
  }

  void reloadData() {
    setState(() {
      futureActivityWeek = fetchActivitiesWeek();
      weekDates = Utils.generateListDates('yyyy-MM-dd', 5);
      weekDatesDisplay = Utils.generateListDates('E d MMMM', 5);
    });
    fetchStravaActivities();
  }

  Future<List<dynamic>> fetchActivitiesWeek() async {
    var response = await CallApi().getRequest(null, '/physicalactivities');
    if (response['status'] == 'Success') {
      return response['data'];
    } else {
      return response['message'];
    }
  }

  // Function that will fetch strava activities if user is connected with strava
  // TODO check when last time it was updated, so duplicates cannot happen
  fetchStravaActivities() async {
    if (await secureStorage.read(key: 'strava_authenticated') != null) {
      var lastRetrieved =
          await secureStorage.read(key: 'strava_last_retrieved');
      var activities =
          await stravaApi.getData('athlete/activities?after=' + lastRetrieved);
      int newLastRetrieved =
          (DateTime.now().millisecondsSinceEpoch / 1000).floor();
      await secureStorage.write(
          key: 'strava_last_retrieved', value: newLastRetrieved.toString());
      if (activities.length > 0) {
        for (var activity in activities) {
          var activityData = {
            'type': activity['type'],
            'time': activity['moving_time'],
            'date_time': activity['start_date_local'],
            'fitness_api_id': 'strava'
          };
          var response =
              await CallApi().postRequest(activityData, '/physicalactivities');
        }
      }
    }
  }
}
