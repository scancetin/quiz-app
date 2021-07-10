import 'package:flutter/material.dart';

class LeaderBoardWidget extends StatelessWidget {
  final String photoUrl;
  final String name;
  final int totalPoint;
  const LeaderBoardWidget({Key key, this.name, this.photoUrl, this.totalPoint}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      color: Color(0xFF4D2A69),
      child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(photoUrl),
          ),
          title: Text(name),
          trailing: Text(
            totalPoint.toString(),
            style: TextStyle(fontSize: 30),
          )),
    );
  }
}
