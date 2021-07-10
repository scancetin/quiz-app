import 'package:flutter/material.dart';
import 'package:quiz_app/screens/leaderboard_page.dart';
import 'package:quiz_app/screens/status_page.dart';

class TabBarOrientation extends StatefulWidget {
  TabBarOrientation({Key key}) : super(key: key);

  @override
  _TabBarOrientationState createState() => _TabBarOrientationState();
}

class _TabBarOrientationState extends State<TabBarOrientation> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxisScrolled) {
          return [
            SliverAppBar(
              floating: true,
              snap: true,
              title: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: "Quiz"),
                  Tab(text: "Leaderboard"),
                ],
              ),
            )
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            StatusPage(),
            LeaderBoardPage(),
          ],
        ),
      ),
    );
  }
}
