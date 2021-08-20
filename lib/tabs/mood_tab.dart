import 'package:bizzfit/api.dart';
import 'package:bizzfit/constants.dart';
import 'package:bizzfit/widgets/navigation_bar.dart';
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

  @override
  Widget build(BuildContext context) {
    final moodBuilder = FutureBuilder<List<dynamic>>(
        future: futureMoodWeek,
        builder: (context, snapshot) {
          Widget activityListWidget;
          if (snapshot.hasData) {
            activityListWidget = SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              return ListTile(
                leading: Utils.moodIcons[snapshot.data[index]['state']],
                title: Text(Utils.moods[snapshot.data[index]['state']]),
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
        child: CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(onRefresh: () async {
            reloadData();
          }),
          moodBuilder
        ],
      ),
    );
  }

  void reloadData() {
    setState(() {
      futureMoodWeek = fetchMoodsWeek();
      weekDates = Utils.generateListDates('yyyy-MM-dd', 5);
      weekDatesDisplay = Utils.generateListDates('E d MMMM', 5);
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
  
}
