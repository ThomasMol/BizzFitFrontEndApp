import 'package:bizzfit/constants.dart';
import 'package:bizzfit/fitness_apis/fitbit/api.dart';
import 'package:bizzfit/fitness_apis/strava/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PhysicalActivityTab extends StatefulWidget {
  static const title = 'Activities';
  static const icon = Icon(CupertinoIcons.chart_bar_square_fill);

  @override
  _PhysicalActivityTabState createState() => _PhysicalActivityTabState();
}

class _PhysicalActivityTabState extends State<PhysicalActivityTab> {
  Future<List<dynamic>> futureActivityWeek;
  final secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    fetchFitnessApiActivities();
    futureActivityWeek = fetchActivitiesWeek();
  }

  void reloadData() {
    fetchFitnessApiActivities();
    setState(() {
      futureActivityWeek = fetchActivitiesWeek();
    });
  }

  void fetchFitnessApiActivities() async {
    if (await secureStorage.read(key: 'fitbit_authenticated') != null) {
      FitbitApi().fetchNewActivitiesAndStore();
    }
    if (await secureStorage.read(key: 'strava_authenticated') != null) {
      StravaApi().fetchStravaActivities();
    }
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
