import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

//ChangeNotifier 클래스
//이 오브젝트가 변경될때마다 아래에서 사용된 모든 위젯들은 Notication을 받음.
class JoinOrLogin extends ChangeNotifier{
  bool _isJoin = false;

  bool get isJoin => _isJoin;
  
  void toggle(){
    _isJoin = !_isJoin;

    //이 클래스를 사용하고 있는 위젯들에게 알림 => 다시실행 => blue에서 redfh
    notifyListeners();
  }
}