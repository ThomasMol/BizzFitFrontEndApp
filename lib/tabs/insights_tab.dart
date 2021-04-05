import 'package:bizzfit/api.dart';
import 'package:flutter/cupertino.dart';
import '../navigation_bar.dart';
import '../api.dart';
import 'package:flutter/material.dart';
import '../widgets.dart';

class InsightsTab extends StatefulWidget {
  static const title = 'Insights';
  static const icon = Icon(CupertinoIcons.chart_pie_fill);

  @override
  _InsightsTabState createState() => _InsightsTabState();
}

class _InsightsTabState extends State<InsightsTab> {
  Future<dynamic> futureInsights;
  List<Icon> moodIcons = [
    Icon(Icons.sentiment_very_dissatisfied, color: Colors.deepOrange, size: 42),
    Icon(Icons.sentiment_dissatisfied, color: Colors.orange, size: 42),
    Icon(Icons.sentiment_neutral, color: Colors.blueGrey, size: 42),
    Icon(Icons.sentiment_satisfied, color: Colors.green, size: 42),
    Icon(Icons.sentiment_very_satisfied, color: Colors.lightGreen, size: 42)
  ];

  @override
  void initState() {
    super.initState();
    futureInsights = fetchFutureInsights();
  }

  Future fetchFutureInsights() async {
    var response = await CallApi().getRequest(null, '/insights/mentalstate');
    if (response['status'] == 'Success') {
      print(response['data']);
      return response['data'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final builderInsights = FutureBuilder<dynamic>(
        future: futureInsights,
        builder: (context, snapshot) {
          Widget newsListSliver;
          if (snapshot.hasData) {
            newsListSliver = SliverToBoxAdapter(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                    child: Column(children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Today',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                      SizedBox(height: 10),
                      Card(
                          child: Column(children: [
                        ListTile(
                          trailing:
                              moodIcons[snapshot.data['average_mental_today']],
                        title: Text('Average mood'),
                        ),
                        ListTile(
                          trailing:
                              Text(snapshot.data['average_physical_today'].toString()),
                          title: Text('Average physical activity points gained'),
                        ),
                      ])),
                      SizedBox(height: 40),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Last 7 days',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                      SizedBox(height: 10),
                      Card(
                          child: ListTile(
                        leading:
                            moodIcons[snapshot.data['average_mental_week']],
                        title: Text(
                            snapshot.data['average_mental_week'].toString()),
                        trailing: Text('Average mood'),
                      )),
                      SizedBox(height: 10),
                    ])));
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
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            refreshData();
          },
        ),
        builderInsights,
      ],
    )));
  }

  void refreshData() {
    setState(() {
      futureInsights = fetchFutureInsights();
    });
  }
}
