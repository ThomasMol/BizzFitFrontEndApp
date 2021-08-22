import 'package:bizzfit/constants.dart';
import 'package:bizzfit/fitness_apis/strava/api.dart';
import 'package:bizzfit/models/strava_athlete_activity.dart';
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
  final secureStorage = FlutterSecureStorage();
  StravaApi stravaApi = StravaApi();

  @override
  void initState() {
    super.initState();
    futureActivityWeek = fetchActivitiesWeek();   
    fetchStravaActivities(); 
  }

  void reloadData() {
    setState(() {
      futureActivityWeek = fetchActivitiesWeek();      
    });
  }

  Future<List<dynamic>> fetchActivitiesWeek() async {
    final response = await supabase
        .from('physical_activities')
        .select()
        .order('date_time')
        .execute();
    if (response.error != null && response.status != 406) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.error.message)));
      return null;
    } else {
      return response.data;
    }
  }

  // Function that will fetch strava activities if user is connected with strava
  // TODO check when last time it was updated, so duplicates cannot happen
  // Checking with last_retrieved almost works: does not work when you remove strava api
  // auth, so users can re auth their strava acc and keep loading their past activities  
  void fetchStravaActivities() async {
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
        List<dynamic> dbActivities = [];
        for (var activity in activities) {
          StravaAthleteActivity stravaAthleteActivity =
              StravaAthleteActivity.fromJson(activity);
          final dbActivity = {
            'user_id': supabase.auth.user().id,
            'type': stravaAthleteActivity.type,
            'time': stravaAthleteActivity.movingTime,
            'date_time': stravaAthleteActivity.startDateLocal,
            'points': 0
          };
          dbActivities.add(dbActivity);
        }
        final response = await supabase
            .from('physical_activities')
            .insert(dbActivities)
            .execute();
        if (response.error != null && response.status != 406) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(response.error.message)));
        } else {
          reloadData();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final activityBuilder = FutureBuilder<List<dynamic>>(
        future: futureActivityWeek,
        builder: (context, snapshot) {
          Widget activityListWidget;
          if (snapshot.hasData && snapshot.data.length > 0) {
            activityListWidget = SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              return ListTile(
                leading: Icon(Icons.run_circle),
                title: Text(snapshot.data[index]['type']),
                subtitle: Text(snapshot.data[index]['date_time']),
                trailing: Text(snapshot.data[index]['points'].toString()),
              );
            }, childCount: snapshot.data.length));
          } else if (snapshot.hasData && snapshot.data.length == 0) {
            activityListWidget = SliverToBoxAdapter(
                child: ListTile(
              title: Text('No data'),
            ));
          } else {
            activityListWidget = SliverToBoxAdapter(
              child: CupertinoActivityIndicator(),
            );
          }

          return activityListWidget;
        });

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(onRefresh: () async {
            reloadData();
          }),
          activityBuilder
        ],
      ),
    );
  }
}
