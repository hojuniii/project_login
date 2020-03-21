import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_login/data/join_or_login.dart';
import 'package:project_login/helper/login_backgorund.dart';
import 'package:project_login/screen/forgot_pw.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //화면 사이즈를 가져온다. final 키워드로 Size 인스턴스를 변경하지 못하게 선언.
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        //모든 스택을 화면의 정중앙에
        alignment: Alignment.center,
        children: <Widget>[
          CustomPaint(
            //화면 사이즈를 던져줌
            size: size,
            painter: LoginBackground(
                isJoin: Provider.of<JoinOrLogin>(context).isJoin),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              _logoImage,
              //인풋필드 Stack
              Stack(
                children: <Widget>[
                  _inputForm(size),
                  _authButton(size),
                ],
              ),

              //Text위의 갭을 설정
              Container(height: size.height * 0.1),
              //텍스트에 기능을 추가하기 위해 GestureDetector 위젯으로 감싸줌
              Consumer<JoinOrLogin>(
                builder: (context, joinOrLogin, child) => GestureDetector(
                    onTap: () {
                      joinOrLogin.toggle();
                    },
                    child: Text(
                      joinOrLogin.isJoin
                          ? "Already Have an Account? Sign in"
                          : "Don't Have an Account? create One",
                      style: TextStyle(
                          color: joinOrLogin.isJoin ? Colors.red : Colors.blue),
                    )),
              ),

              //위에서 선언한 화면의 Size 변수를 통해 갭을 설정, 빈 컨테이너를 삽입함으로서
              Container(height: size.height * 0.05)
            ],
          )
        ],
      ),
    );
  }

  void _register(BuildContext context) async {
    
    final AuthResult result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: _emailController.text.trim(), password: _passwordController.text);
    final FirebaseUser user = result.user;

    if (user == null) {
      final snackBar = SnackBar(content: Text('Please try again later.'));
      Scaffold.of(context).showSnackBar(snackBar);
    }
    //Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage(email: user.email)));
  }

  void _login(BuildContext context) async {
    final AuthResult result =await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _emailController.text.trim(), password: _passwordController.text);
    final FirebaseUser user = result.user;

    if (user == null) {
      final snackBar = SnackBar(content: Text('Please try again later.'));
      Scaffold.of(context).showSnackBar(snackBar);
    }
    //Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage(email: user.email)));
}

  //만약 파라미터없이 선언하고 싶으면 get을 주고 위에서 _logoImage를 호출하면됨
  Widget get _logoImage => Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 40, left: 24, right: 24),
          child: FittedBox(
            fit: BoxFit.contain,
            child: CircleAvatar(
                backgroundImage: AssetImage('assets/main_logo.gif')),
          ),
        ),
      );

  Widget _authButton(Size size) => Positioned(
        left: size.width * 0.15,
        right: size.width * 0.15,
        bottom: 0,
        child: SizedBox(
          height: 50,
          child: Consumer<JoinOrLogin>(
            builder: (context, joinOrLogin, child) => RaisedButton(
                child: Text(joinOrLogin.isJoin ? " Join" : "Login",
                    style: TextStyle(fontSize: 15, color: Colors.white)),
                color: joinOrLogin.isJoin ? Colors.red : Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),

                //Login버튼 클릭시 동작
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    joinOrLogin.isJoin ? _register(context) : _login(context);
                  }
                }),
          ),
        ),
      );

  Widget _inputForm(Size size) {
    return Padding(
      //EdgeInsetes.symmetric (위아래는 vertical, 양옆은 horizontal)
      //only는 LRTB를 각각설정가능
      padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0, bottom: 32),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)), //카드 모서리를 줌
        elevation: 8,
        child: Padding(
          //폼 내부 패딩
          padding: const EdgeInsets.all(12.0),
          child: Form(
            //formKey를 사용해서 form의 상태를 접근 가능
            key: _formKey,
            child: Column(
              //Column의 정렬은 crossAxisAlignment로
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      icon: Icon(Icons.account_circle), labelText: 'email'),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "Please input correct Email.";
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  //패스워드 텍스트로 ****
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(
                      icon: Icon(Icons.vpn_key), labelText: 'password'),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "Please input correct Password.";
                    } else {
                      return null;
                    }
                  },
                ),
                Container(height: 8),
                Consumer<JoinOrLogin>(
                  builder: (context, value, child) => Opacity(
                      opacity: value.isJoin ? 0 : 1,
                      child: GestureDetector(
                          onTap: value.isJoin
                              ? null
                              : () {
                                  goToForgetPw(context);
                                },
                          child: Text("Forgot Password?",style: TextStyle(color: Colors.black45),),
                          )
                  ),
                ),
                Container(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  goToForgetPw(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ForgetPw()));
  }
}
