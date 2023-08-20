import 'package:flutter/material.dart';

//다이얼로그 위젯
class ShowDialog {
  showAlertDialog(context, message) {
    AlertDialog(
      title: Text(message, style: const TextStyle(fontSize: 16)),
      actions: <Widget>[
        TextButton(
          child: const Text('확인'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
