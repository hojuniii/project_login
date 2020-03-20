import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_login/data/join_or_login.dart';
import 'package:project_login/screen/login.dart';
import 'package:project_login/screen/main_page.dart';
import 'package:provider/provider.dart';

void main() {
  return runApp(MyApp());
}

//Provider를 통해 JoinOrLogin을 모든 하위 위젯에서 사용 가능
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Splash(),
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
        //유저가 sign in 을했을때 FirebaseUser를 우리에게 주고 signout을 했을때 또 전달됨
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, snapshot) {
          //로그인이 되어있지 않으면
          if (snapshot.data == null) {
            return ChangeNotifierProvider<JoinOrLogin>.value(
              value: JoinOrLogin(),
              child: AuthPage());
          } else {
            return MainPage(email: snapshot.data.email);
          }
        }
    );
  }
}
