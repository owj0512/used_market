import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../component/input_field.dart';
import '../../component/loading.dart';
import '../../component/show_message.dart';

class PasswordChange {
  final _formKey = GlobalKey<FormState>(); //텍스트필드 유효성 검증을 위한 변수
  dynamic currentPwController = TextEditingController(); //현재 비밀번호
  dynamic newPwController = TextEditingController(); //새 비밀번호
  dynamic newPwCheckController = TextEditingController(); //새 비밀번호 확인

  passwordChange(context) {
    showDialog(
        useRootNavigator: false,
        context: context,
        builder: (BuildContext context) => SingleChildScrollView(
              child: Dialog(
                child: Form(
                  key: _formKey,
                  child: Container(
                      width: 600,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            '현재 비밀번호를 입력해주세요',
                            textAlign: TextAlign.center,
                            style: TextStyle(),
                          ),
                          InputField().inputField(
                            TextFormField(
                              controller: currentPwController,
                              maxLength: 30,
                              obscureText: true,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '현재 비밀번호',
                                  counterText: ''),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '현재 비밀번호를 입력해주세요';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            '변경하려는 비밀번호를 입력해주세요',
                            textAlign: TextAlign.center,
                            style: TextStyle(),
                          ),
                          InputField().inputField(
                            TextFormField(
                              controller: newPwController,
                              maxLength: 30,
                              obscureText: true,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '새 비밀번호',
                                  counterText: ''),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '비밀번호를 입력해주세요';
                                } else if (value.length < 6) {
                                  return '비밀번호를 6자 이상으로 입력해주세요';
                                } else if (newPwController.text ==
                                    currentPwController.text) {
                                  return '현재 비밀번호와 같습니다';
                                }
                                return null;
                              },
                            ),
                          ),
                          InputField().inputField(
                            TextFormField(
                              controller: newPwCheckController,
                              maxLength: 30,
                              obscureText: true,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '새 비밀번호 확인',
                                  counterText: ''),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '비밀번호를 입력해주세요';
                                } else if (value != newPwController.text) {
                                  return '비밀번호가 다릅니다';
                                }
                                return null;
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                  child: Container(
                                      margin: const EdgeInsets.all(10),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: const Text('변경',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18))),
                                  //변경 버튼을 눌렀을 때
                                  onTap: () async {
                                    if (_formKey.currentState!.validate()) {
                                      Loading().loading(context, '변경중입니다');
                                      try {
                                        //현재 사용자 정보를 불러오고, 입력받은 현재 비밀번호를 통해 재인증함
                                        User user = FirebaseAuth
                                            .instance.currentUser!;
                                        UserCredential result = await user
                                            .reauthenticateWithCredential(
                                                EmailAuthProvider.credential(
                                                    email:
                                                        user.email.toString(),
                                                    password:
                                                        currentPwController
                                                            .text));
                                        //재인증이 통과되면 새로운 비밀번호로 변경함
                                        await user.updatePassword(
                                            newPwController.text);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        ShowMessage()
                                            .showToastBlue('비밀번호 변경이 완료되었습니다');
                                        //변경 실패 시 처리
                                      } on FirebaseAuthException catch (e) {
                                        Navigator.pop(context);
                                        if (e.message!.contains(
                                            'The password is invalid')) {
                                          ShowMessage()
                                              .showToastRed('현재 비밀번호 틀립니다');
                                        } else {
                                          ShowMessage().showToastRed(
                                              '오류가 발생했습니다. 잠시 후 다시 시도해주세요');
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
                                            color: Colors.white,
                                            fontSize: 18))),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          )
                        ],
                      )),
                ),
              ),
            ));
  }
}
