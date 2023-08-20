import 'package:flutter/material.dart';

//텍스트 입력 필드. child는 TextFormField같은 위젯을 파라미터로 받음
class InputField {
  inputField(child) {
    return Container(
      width: 550,
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        child: child
    );
  }
}