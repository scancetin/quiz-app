import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/widgets/leaderboard_widget.dart';

class LeaderBoardPage extends StatelessWidget {
  const LeaderBoardPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CollectionReference users = FirebaseFirestore.instance.collection('users');

    return StreamBuilder<QuerySnapshot>(
      stream: users.orderBy("totalPoint", descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        return ListView(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            return LeaderBoardWidget(
              name: document.get("name"),
              photoUrl: document.get("photoUrl"),
              totalPoint: document.get("totalPoint"),
            );
          }).toList(),
        );
      },
    );
  }
}
