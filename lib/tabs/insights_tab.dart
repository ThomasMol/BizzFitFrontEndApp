import 'package:bizzfit/api.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/navigation_bar.dart';
import '../api.dart';
import 'package:flutter/material.dart';
import '../utils.dart';

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

  List<String> moods = ['Awful', 'Bad', 'Neutral', 'Good', 'Amazing'];

  @override
  void initState() {
    super.initState();
    futureInsights = fetchFutureInsights();
  }

  Future fetchFutureInsights() async {
    var response = await CallApi().getRequest(null, '/insights/get');
    if (response['status'] == 'Success') {
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
                            subtitle:
                                moodCounts(snapshot.data['grouped_today']),
                            leading: Text('Moods')),
                        ListTile(
                          leading:
                              moodIcons[snapshot.data['average_mental_today']],
                          title: Text(
                              moods[snapshot.data['average_mental_today']]),
                          subtitle: Text('Average mood'),
                        ),
                        ListTile(
                          leading: Text(
                              snapshot.data['average_physical_today']
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          title:
                              Text('Average physical activity points gained'),
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
                          child: Column(children: [
                        ListTile(
                            subtitle: moodCounts(snapshot.data['grouped_week']),
                            leading: Text('Moods')),
                        ListTile(
                          leading:
                              moodIcons[snapshot.data['average_mental_week']],
                          title:
                              Text(moods[snapshot.data['average_mental_week']]),
                          subtitle: Text('Average mood'),
                        ),
                        ListTile(
                          leading: Text(
                              snapshot.data['average_physical_week'].toString(),
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          title:
                              Text('Average physical activity points gained'),
                        ),
                      ])),
                      SizedBox(height: 40),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Last 30 days',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                      SizedBox(height: 10),
                      Card(
                          child: Column(children: [
                        ListTile(
                            subtitle:
                                moodCounts(snapshot.data['grouped_month']),
                            leading: Text('Moods')),
                        ListTile(
                          leading:
                              moodIcons[snapshot.data['average_mental_month']],
                          title: Text(
                              moods[snapshot.data['average_mental_month']]),
                          subtitle: Text('Average mood'),
                        ),
                        ListTile(
                          leading: Text(
                              snapshot.data['average_physical_month']
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          title:
                              Text('Average physical activity points gained'),
                        ),
                      ])),
                    ])));
          } else {
            newsListSliver = SliverToBoxAdapter(
              child: CupertinoActivityIndicator(),
            );
          }
          return newsListSliver;
        });

    return SafeArea(
        child: CustomScrollView(
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            refreshData();
          },
        ),
        builderInsights,
      ],
    ));
  }

  void refreshData() {
    setState(() {
      futureInsights = fetchFutureInsights();
    });
  }

  Widget moodCounts(dynamic data) {
    List<Widget> moodItems = [];
    for (var item in data) {
      Widget column = Column(
          children: [moodIcons[item['state']], Text(item['total'].toString())]);
      moodItems.add(column);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: moodItems,
    );
  }
}
