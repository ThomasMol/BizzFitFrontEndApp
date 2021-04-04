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

  @override
  void initState() {
    super.initState();
    futureInsights = fetchFutureInsights();
  }

  Future fetchFutureInsights() async {
    var response = await CallApi().getRequest(null, '/insights/mentalstate');
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
                child: Column(
              children: [
                Text(snapshot.data['average_mental_month'].toString()),
              ],
            ));
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
