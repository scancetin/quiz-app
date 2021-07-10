import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/provider/sign_in.dart';
import 'package:quiz_app/widgets/login_widget.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
          builder: (context, snapshot) {
            return Column(
              children: [
                Expanded(
                  flex: 6,
                  child: Icon(Icons.all_inclusive_sharp, color: Color(0xFFAD5EED), size: 350),
                ),
                Expanded(
                  child: LoginWidget(),
                ),
                Spacer(),
              ],
            );
          }),
    );
  }
}
