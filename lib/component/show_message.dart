import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//알림 메시지 위젯을 보여주는 클래스
class ShowMessage {
  //빨간색 스낵바
  showSnackBarRed(context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  //파란색 스낵바
  showSnackBarBlue(context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blueAccent,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  //빨간색 토스트 메시지
  void showToastRed(String message) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.redAccent,
      timeInSecForIosWeb: 3,
      webBgColor: '#FF4848'
    );
  }

  //파란색 토스트 메시지
  void showToastBlue(String message) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.blueAccent,
      timeInSecForIosWeb: 3,
      webBgColor: '#4374D9',
    );
  }
}
