import 'package:flutter/material.dart';

//팝업 로딩 다이얼로그를 보여주는 위젯
class Loading {
  Future loading(context, String message) {
    return showDialog(
        useRootNavigator: false,
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => Dialog(
                child: SizedBox(
              width: 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  const Center(child: CircularProgressIndicator()),
                  const SizedBox(height: 20),
                  Text(message),
                  const SizedBox(height: 20),
                ],
              ),
            )));
  }
}
