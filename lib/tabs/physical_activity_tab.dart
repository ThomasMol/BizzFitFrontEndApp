import 'dart:convert';

import 'package:bizzfit/api.dart';
import 'package:bizzfit/navigation_bar.dart';
import 'package:bizzfit/strava/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2_client/oauth2_helper.dart';
import '../utils.dart';
import '../strava/secrets.dart';

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

  @override
  void initState() {
    super.initState();
    futureActivityWeek = fetchActivitiesWeek();

    weekDates = Utils.generateListDates('yyyy-MM-dd', 5);
    weekDatesDisplay = Utils.generateListDates('E d MMMM', 5);
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
        child: Scaffold(
      body: CustomScrollView(
        slivers: [
          NavigationBar(),
          CupertinoSliverRefreshControl(onRefresh: () async {
            reloadData();
          }),
          activityBuilder
        ],
      ),
    ));
  }

  void reloadData() {
    setState(() {
      futureActivityWeek = fetchActivitiesWeek();
      weekDates = Utils.generateListDates('yyyy-MM-dd', 5);
      weekDatesDisplay = Utils.generateListDates('E d MMMM', 5);
    });
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
  fetchStravaActivities() async {
    StravaOAuth2Client stravaOAuth2Client = StravaOAuth2Client();
    OAuth2Helper oAuth2Helper = OAuth2Helper(stravaOAuth2Client,
        grantType: OAuth2Helper.AUTHORIZATION_CODE,
        clientId: stravaClientId,
        clientSecret: stravaSecret,
        scopes: ['activity:read_all']);

    http.Response response = await oAuth2Helper
        .get('https://www.strava.com/api/v3/athlete/activities');
    print(jsonDecode(response.body));
  }
}
