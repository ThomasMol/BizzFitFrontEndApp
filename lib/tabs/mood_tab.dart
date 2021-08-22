import 'package:bizzfit/constants.dart';
import 'package:bizzfit/pages/create_mental_state_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils.dart';

class MoodTab extends StatefulWidget {
  static const title = 'Mood';
  static const icon = Icon(Icons.sentiment_very_satisfied_rounded);

  @override
  _MoodTabState createState() => _MoodTabState();
}

class _MoodTabState extends State<MoodTab> {
  Future<List<dynamic>> futureMoodWeek;
  List<String> weekDates;
  List<String> weekDatesDisplay;

  @override
  void initState() {
    super.initState();
    futureMoodWeek = fetchMoodsWeek();
    weekDates = Utils.generateListDates('yyyy-MM-dd', 5);
    weekDatesDisplay = Utils.generateListDates('E d MMMM', 5);
  }

  void reloadData() {
    setState(() {
      futureMoodWeek = fetchMoodsWeek();
      weekDates = Utils.generateListDates('yyyy-MM-dd', 5);
      weekDatesDisplay = Utils.generateListDates('E d MMMM', 5);
    });
  }

  void openCreateMoodPage() {
    Navigator.of(context, rootNavigator: true)
        .push<void>(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => CreateMentalState(),
          ),
        )
        .then((value) => {
              setState(() {
                futureMoodWeek = fetchMoodsWeek();
              })
            });
  }

  Future<List<dynamic>> fetchMoodsWeek() async {
    final response = await supabase
        .from('mental_states')
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
    final moodBuilder = FutureBuilder<List<dynamic>>(
        future: futureMoodWeek,
        builder: (context, snapshot) {
          Widget activityListWidget;
          if (snapshot.hasData && snapshot.data.length > 0) {
            activityListWidget = SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              return ListTile(
                leading: Utils.moodIcons[snapshot.data[index]['state']],
                title: Text(Utils.moods[snapshot.data[index]['state']]),
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
        child: Scaffold(
      body: CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(onRefresh: () async {
            reloadData();
          }),
          moodBuilder
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openCreateMoodPage,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    ));
  }
}
