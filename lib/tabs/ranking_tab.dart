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
  Future<List<dynamic>> futureOrganizationRanking;
  Future<List<dynamic>> futureInOrganizationRanking;
  Future<int> futureMyRanking;
  Future<int> futureMyOrganizationRanking;

  @override
  void initState() {
    super.initState();
    futureOrganizationRanking = fetchOrganizationRanking();
    futureInOrganizationRanking = fetchInOrganizationRanking();
    futureMyRanking = fetchMyRanking();
    futureMyOrganizationRanking = fetchMyOrganizationRanking();
  }

  Future<List<dynamic>> fetchOrganizationRanking() async {
    var response = await CallApi().getRequest(null, '/ranking/topten');
    if (response['status'] == 'Success') {
      return response['data'];
    }
  }

  Future<List<dynamic>> fetchInOrganizationRanking() async {
    var response = await CallApi().getRequest(null, '/ranking/myorganization');
    if (response['status'] == 'Success') {
      return response['data'];
    }
  }

  Future<int> fetchMyRanking() async {
    var response = await CallApi().getRequest(null, '/ranking/myranking');
    if (response['status'] == 'Success') {
      return response['data'];
    }
  }

  Future<int> fetchMyOrganizationRanking() async {
    var response =
        await CallApi().getRequest(null, '/ranking/myorganizationranking');
    if (response['status'] == 'Success') {
      return response['data'];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Top ten of organizations builder
    final builderOrganizationRanking = FutureBuilder<List<dynamic>>(
        future: Future.wait(
            [futureOrganizationRanking, futureMyOrganizationRanking]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          Widget newsListSliver;
          if (snapshot.hasData) {
            newsListSliver = SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              int position = index + 1;
              return ListTile(
                  leading: Text(position.toString()),
                  title: Text(snapshot.data[0][index]['name']),
                  trailing: Text(snapshot.data[0][index]['score'].toString()),
                  subtitle: snapshot.data[1] == position
                      ? Text('Your organization is here!')
                      : null);
            }, childCount: snapshot.data[0].length));
          } else {
            newsListSliver = SliverToBoxAdapter(
              child: CupertinoActivityIndicator(),
            );
          }
          return newsListSliver;
        });

    // Top ten of users within organization builder
    final builderInOrganizationRanking = FutureBuilder<List<dynamic>>(
        future: Future.wait([futureInOrganizationRanking, futureMyRanking]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          Widget newsListSliver;
          if (snapshot.hasData) {
            newsListSliver = SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              int position = index + 1;
              return ListTile(
                  leading: Text(position.toString()),
                  title: Text(snapshot.data[0][index]['first_name']),
                  trailing: Text(snapshot.data[0][index]['score'].toString()),
                  subtitle: snapshot.data[1] == position
                      ? Text('You are here!')
                      : null);
            }, childCount: snapshot.data[0].length));
          } else {
            newsListSliver = SliverToBoxAdapter(
              child: CupertinoActivityIndicator(),
            );
          }
          return newsListSliver;
        });

    // Create scaffolding
    return SafeArea(
        child: Scaffold(
            body: CustomScrollView(
      slivers: [
        NavigationBar(),
        CupertinoSliverRefreshControl(onRefresh: () async {
          reloadData();
        }),
        SliverToBoxAdapter(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text(
                  'Top organizations',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ))),
        builderOrganizationRanking,
        SliverToBoxAdapter(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text(
                  'Your rankings',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ))),
        builderInOrganizationRanking
      ],
    )));
  }

  void reloadData() {
    setState(() {
      futureOrganizationRanking = fetchOrganizationRanking();
      futureInOrganizationRanking = fetchInOrganizationRanking();
      futureMyRanking = fetchMyRanking();
      futureMyOrganizationRanking = fetchMyOrganizationRanking();
    });
  }
}
