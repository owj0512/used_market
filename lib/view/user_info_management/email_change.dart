import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../component/input_field.dart';
import '../../component/loading.dart';
import '../../component/show_message.dart';

class EmailChange {
  final _formKey = GlobalKey<FormState>(); //텍스트필드 유효성 검증을 위한 변수
  dynamic emailController = TextEditingController(); //현재 이메일 주소
  dynamic passwordController = TextEditingController(); //비밀번호
  dynamic newEmailController = TextEditingController(); //새 이메일 주소

  emailChange(context) {
    showDialog(
      useRootNavigator: false,
      context: context,
      builder: (buildContext) => SingleChildScrollView(
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
                  const SizedBox(height: 10),
                  const Text(
                    '현재 이메일 주소와 비밀번호를 입력해주세요',
                    textAlign: TextAlign.center,
                    style: TextStyle(),
                  ),
                  InputField().inputField(
                    TextFormField(
                      controller: emailController,
                      maxLength: 30,
                      decoration: const InputDecoration(border: InputBorder.none, hintText: '현재 이메일 주소', counterText: ''),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '이메일 주소를 입력해주세요';
                        } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return "이메일 형식에 맞게 입력해주세요";
                        }
                        return null;
                      },
                    ),
                  ),
                  InputField().inputField(
                    TextFormField(
                      controller: passwordController,
                      maxLength: 30,
                      obscureText: true,
                      decoration: const InputDecoration(border: InputBorder.none, hintText: '비밀번호', counterText: ''),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '비밀번호를 입력해주세요';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('변경하실 이메일 주소를 입력해주세요', textAlign: TextAlign.center),
                  InputField().inputField(
                    TextFormField(
                      controller: newEmailController,
                      maxLength: 30,
                      decoration: const InputDecoration(border: InputBorder.none, hintText: '새 이메일 주소', counterText: ''),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '이메일 주소를 입력해주세요';
                        } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return '이메일 형식에 맞게 입력해주세요';
                        } else if (newEmailController.text == emailController.text) {
                          return '변경하려는 이메일이 현재 이메일과 같습니다';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '※ 발송된 이메일을 통해 인증을 완료해야 로그인할 수 있습니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          child: Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5)),
                              child: const Text('변경', style: TextStyle(color: Colors.white, fontSize: 18))),
                          //변경 버튼을 눌렀을 때
                          onTap: () async {
                            //입력 텍스트 유효성 검증
                            if (_formKey.currentState!.validate()) {
                              Loading().loading(context, '변경중입니다');
                              //이메일 주소를 변경하려면 로그인-재인증 과정을 거쳐야함
                              try {
                                //이메일 찾기는 로그인페이지와 마이페이지 두 군데에서 제공되므로 먼저 로그인 되어있는지 확인하고 로그인이 안되어있으면 로그인을 먼저 처리함
                                if (FirebaseAuth.instance.currentUser == null) {
                                  UserCredential userCredential = await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
                                }
                                //로그인된 사용자 정보를 User타입의 변수에 저장하고 재인증을 함
                                User user = FirebaseAuth.instance.currentUser!;
                                UserCredential currentUser = await user.reauthenticateWithCredential(
                                    EmailAuthProvider.credential(email: emailController.text, password: passwordController.text));
                                //파이어베이스 Authentication에서 이메일 주소를 변경함
                                await user.updateEmail(newEmailController.text);
                                //파이어베이스 DB에서 이메일 주소를 변경함
                                await FirebaseFirestore.instance.collection('memberInfo').doc(user.uid).update({
                                  'email': newEmailController.text,
                                });
                                //변경된 이메일 주소로 인증 메일 발송
                                await user.sendEmailVerification();
                                Navigator.pop(context);
                                Navigator.pop(context);
                                ShowMessage().showToastBlue('이메일 주소 변경이 완료되었습니다. 발송된 이메일을 확인하고 인증 후 로그인해주세요.');
                                //변경 실패 시 처리
                              } on FirebaseAuthException catch (e) {
                                Navigator.pop(context);
                                if (e.message!.contains('There is no user record corresponding ')) {
                                  ShowMessage().showToastRed('가입되지 않은 이메일 주소입니다');
                                } else if (e.message!.contains('The password is invalid')) {
                                  ShowMessage().showToastRed('비밀번호가 틀립니다');
                                } else {
                                  ShowMessage().showToastRed(e.message!);
                                }
                              }
                            }
                          }),
                      GestureDetector(
                        child: Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: Colors.grey[350], borderRadius: BorderRadius.circular(5)),
                            child: const Text('취소', style: TextStyle(color: Colors.white, fontSize: 18))),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  )
                ],
              )),
        )),
      ),
    );
  }
}
