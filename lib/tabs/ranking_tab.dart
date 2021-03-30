import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../navigation_bar.dart';
import '../api.dart';
import '../widgets.dart';

class RankingTab extends StatefulWidget {
  static const title = 'Ranking';
  static const icon = Icon(CupertinoIcons.list_number);

  @override
  _RankingTabState createState() => _RankingTabState();
}

class _RankingTabState extends State<RankingTab> {
  Future<List<dynamic>> futureRanking;

  @override
  void initState() {
    super.initState();
    futureRanking = fetchOrganizationRanking();
  }

  Future<List<dynamic>> fetchOrganizationRanking() async {
    var response = await CallApi().getRequest(null, '/toptenranking');
    if (response['status'] == 'Success') {
      return response['data'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final rankingBuilder = FutureBuilder<List<dynamic>>(
        future: futureRanking,
        builder: (context, snapshot) {
          Widget newsListSliver;
          if (snapshot.hasData) {
            newsListSliver = SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              int position = index + 1;
              return ListTile(
                leading: Text(position.toString()),
                title: Text(snapshot.data[index]['name']),
                trailing: Text(snapshot.data[index]['score'].toString()),
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
        rankingBuilder
      ],
    )));
  }

  void reloadData() {
    setState(() {
      futureRanking = fetchOrganizationRanking();
    });
  }
}
