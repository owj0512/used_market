import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 뒤로가기 버튼 눌렀을 때 확인 창을 띄워주는 메서드
class OnBackPressed {
  Future<bool?> onBackPressed(BuildContext context, String message) async {
    showDialog(
      useRootNavigator: false,
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text(message,
                style: const TextStyle(fontSize: 16)),
            actions: <Widget>[
              TextButton(
                child: const Text('네'),
                onPressed: () {
                  Navigator.pop(context);
                  if(Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    SystemNavigator.pop();
                  }
                },
              ),
              TextButton(
                child: const Text('아니요'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
    return null;
  }
}