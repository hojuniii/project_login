import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginBackground extends CustomPainter{


  LoginBackground({@required this.isJoin});
  final bool isJoin;

  @override
  void paint(Canvas canvas, Size size) {
    //원을 그려보자
    //.. 은 Paint()..color = Colors.blue; 까지를 한가지 값으로 만들어줌
    Paint paint = Paint()..color = isJoin? Colors.red : Colors.blue;

    canvas.drawCircle(Offset(size.width*0.5,size.height*0.2), size.height * 0.5, paint);
  }


  //뒷배경을 계속 다시그릴지 말지
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

}