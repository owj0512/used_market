import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../component/input_field.dart';
import '../../component/show_message.dart';

class PasswordFind {
  final _formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();

  passwordFind(context) {
    showDialog(
        useRootNavigator: false,
        context: context,
        builder: (BuildContext context) => Dialog(
                child: Form(
              key: _formKey,
              child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '비밀번호 재설정 메일이 발송됩니다.\n 이메일 주소를 입력해주세요',
                      ),
                      InputField().inputField(
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          maxLength: 30,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: '이메일 주소',
                              counterText: ''),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '이메일을 입력해주세요';
                            } else if (!RegExp(r'\S+@\S+\.\S+')
                                .hasMatch(value)) {
                              return "이메일 형식에 맞게 입력해주세요";
                            }
                            return null;
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                              child: Container(
                                  margin: const EdgeInsets.all(10),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: const Text('메일 전송',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18))),
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    await FirebaseAuth.instance
                                        .sendPasswordResetEmail(
                                            email: emailController.text);
                                    Navigator.pop(context);
                                    ShowMessage().showSnackBarBlue(context,
                                        '비밀번호 변경 메일이 발송 되었습니다. 메일이 수신되지 않을 경우 스팸메일함을 확인해주세요');
                                  } on FirebaseAuthException catch (e) {
                                    if (e.message!.contains(
                                        'There is no user record corresponding to this identifier')) {
                                      ShowMessage()
                                          .showToastRed('가입되지 않은 이메일 주소입니다');
                                    }
                                  }
                                }
                              }),
                          GestureDetector(
                            child: Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.grey[350],
                                    borderRadius: BorderRadius.circular(5)),
                                child: const Text('취소',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18))),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      )
                    ],
                  )),
            )));
  }
}
