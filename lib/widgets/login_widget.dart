import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/provider/sign_in.dart';
import 'package:quiz_app/widgets/tabbar.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key key}) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final User currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    if (currentUser != null) {
      addToFirestore();
    }

    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          return GestureDetector(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 50),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50)),
              child: Text("Sign In with Google", style: TextStyle(color: Colors.black, fontSize: 20)),
            ),
            onTap: () {
              if (currentUser == null) {
                provider.login();
              } else {
                addToFirestore();
              }
            },
          );
        });
  }

  Future addToFirestore() async {
    if (currentUser != null) {
      final QuerySnapshot result = await FirebaseFirestore.instance.collection('users').where('id', isEqualTo: currentUser.uid).get();
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.length == 0) {
        FirebaseFirestore.instance.collection('users').doc(currentUser.uid).set({
          "name": currentUser.displayName,
          "photoUrl": currentUser.photoURL,
          "email": currentUser.email,
          "id": currentUser.uid,
          "trueCounter": 0,
          "falseCounter": 0,
          "totalPoint": 0,
          "createdAt": DateTime.now(),
        });
      }
      Fluttertoast.showToast(msg: "Login Succesfully");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TabBarOrientation()));
    }
  }
}
