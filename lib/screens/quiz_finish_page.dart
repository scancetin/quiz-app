import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/widgets/tabbar.dart';

class QuizFinishPage extends StatelessWidget {
  final int correctNo;
  const QuizFinishPage({Key key, this.correctNo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CollectionReference users = FirebaseFirestore.instance.collection('users');
    final User user = FirebaseAuth.instance.currentUser;

    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(user.uid).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data.data();
            return Column(
              children: [
                Spacer(),
                Expanded(
                  child: Text((correctNo).toString() + "/10", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 80)),
                ),
                Spacer(),
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: Color(0xFF389396), borderRadius: BorderRadius.circular(25)),
                      child: Text("Main Page", style: TextStyle(color: Colors.black, fontSize: 32)),
                    ),
                    onTap: () {
                      addResults(data["falseCounter"], data["trueCounter"], data["totalPoint"]);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TabBarOrientation()));
                    },
                  ),
                ),
                Spacer(),
              ],
            );
          }
          return CircularProgressIndicator();
        });
  }

  Future<void> addResults(int falseCounter, int trueCounter, int totalPoint) async {
    final CollectionReference users = FirebaseFirestore.instance.collection('users');
    final User user = FirebaseAuth.instance.currentUser;
    users
        .doc(user.uid)
        .update({"falseCounter": falseCounter + 10 - correctNo})
        .then((value) => print("False Added"))
        .catchError((error) => print("Failed to update element: $error"));
    users.doc(user.uid).update({"trueCounter": trueCounter + correctNo}).then((value) => print("True Added")).catchError((error) => print("Failed to update element: $error"));
    users.doc(user.uid).update({"totalPoint": totalPoint + correctNo * 10}).then((value) => print("Points Added")).catchError((error) => print("Failed to update element: $error"));
  }
}
