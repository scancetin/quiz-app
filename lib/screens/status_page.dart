import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/provider/sign_in.dart';
import 'package:quiz_app/screens/game_page.dart';
import 'package:quiz_app/screens/sign_in_page.dart';

class StatusPage extends StatefulWidget {
  StatusPage({Key key}) : super(key: key);

  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(auth.currentUser.uid).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          return Column(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: ChangeNotifierProvider(
                      create: (context) => GoogleSignInProvider(),
                      builder: (context, snapshot) {
                        return IconButton(
                            icon: Icon(
                              Icons.exit_to_app,
                              color: Color(0xff5eedcb),
                            ),
                            onPressed: () {
                              final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInPage()));
                              provider.logout();
                            });
                      }),
                ),
              ),
              Expanded(
                flex: 6,
                child: CircleAvatar(radius: 80, backgroundImage: NetworkImage(data["photoUrl"])),
              ),
              Spacer(),
              Expanded(
                child: Text(
                  data["name"],
                  style: TextStyle(color: Colors.greenAccent, fontSize: 20),
                ),
              ),
              Spacer(),
              Expanded(
                child: Text(
                  data["email"],
                  style: TextStyle(color: Colors.greenAccent, fontSize: 20),
                ),
              ),
              Spacer(),
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    Spacer(),
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(color: Color(0xFF4D2A69), borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("True", style: TextStyle(fontSize: 20)),
                            Text(data["trueCounter"].toString(), style: TextStyle(fontSize: 18)),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(color: Color(0xFF4D2A69), borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("False", style: TextStyle(fontSize: 20)),
                            Text(data["falseCounter"].toString(), style: TextStyle(fontSize: 18)),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Spacer(),
              Expanded(
                flex: 4,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.50,
                  decoration: BoxDecoration(color: Color(0xFF4D2A69), borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Score", style: TextStyle(fontSize: 25)),
                      Text(data["totalPoint"].toString(), style: TextStyle(fontSize: 22)),
                    ],
                  ),
                ),
              ),
              Spacer(),
              Expanded(
                flex: 4,
                child: GestureDetector(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Color(0xFF4D2A69), borderRadius: BorderRadius.circular(15)),
                    child: Text("QUIZ", style: TextStyle(fontSize: 50)),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GamePage(questionNo: 0, correctNo: 0)));
                  },
                ),
              ),
              Spacer(),
            ],
          );
        }
        return CircularProgressIndicator();
      },
    );
  }

 
}
