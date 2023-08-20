import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../component/input_field.dart';
import '../../component/loading.dart';
import '../../component/show_message.dart';
import 'login.dart';

class Withdrawal {
  final _formKey = GlobalKey<FormState>();  //회원탈퇴 시 비밀번호 입력 검증 Form key
  dynamic passwordController = TextEditingController(); //회원탈퇴 시 비밀번호 입력 컨트롤러

  withdrawal(context) {
    return showDialog(
      useRootNavigator: false,
        context: context,
        builder: (BuildContext context) => Dialog(
            child: Form(
              key: _formKey,
              child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('회원탈퇴 시 모든 정보가 삭제됩니다.\n정말 탈퇴하시겠습니까?\n계속하려면 비밀번호를 입력해주세요',
                        textAlign: TextAlign.center,
                        style: TextStyle(),
                      ),
                      InputField().inputField(TextFormField(
                          controller: passwordController,
                          maxLength: 30,
                          obscureText: true,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: '비밀번호',
                              counterText: ''),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '비밀번호를 입력해주세요';
                            }
                            return null;
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                              child: Container(
                                  margin:
                                  const EdgeInsets.all(
                                      10),
                                  padding:
                                  const EdgeInsets.all(
                                      10),
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius:
                                      BorderRadius
                                          .circular(
                                          5)),
                                  child: const Text('탈퇴',
                                      style: TextStyle(
                                          color: Colors
                                              .white,
                                          fontSize:
                                          18))),
                              //탈퇴 버튼을 눌렀을 때
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  try{
                                    Loading().loading(context, '처리중입니다');
                                    //탈퇴하려면 비밀번호를 입력해야 하는데, 서버에 저장된 비밀번호와 직접적으로 비교할 방법이 없으므로, reauthenticateWithCredential 메서드를 통해 재인증하는 방식을 사용함
                                    User user = FirebaseAuth.instance.currentUser!;
                                    dynamic email = user.email; //현재 로그인 중인 사용자의 이메일을 email 변수에 저장
                                    //사용자의 이메일 주소와, 입력한 비밀번호로 재인증을 시도하고, 에러가 발생하지 않으면 비밀번호가 일치하는 것이므로, 탈퇴를 진행함
                                    UserCredential result = await user.reauthenticateWithCredential(EmailAuthProvider.credential(
                                        email: email, password: passwordController.text
                                    ));
                                    //탈퇴 시 탈퇴한 회원 정보를 withdrawnUser 컬렉션에 저장함
                                    await FirebaseFirestore.instance.collection('withdrawnUser').doc(user.uid).set({
                                      'withdrawnDate': DateTime.now(),
                                      'email': user.email.toString(),
                                    });
                                    await user.delete();
                                    await LoginState.storage.delete(key: 'login');
                                    FirebaseAuth.instance.signOut();
                                    ShowMessage().showToastBlue('탈퇴 처리가 완료되었습니다. 이용해주셔서 감사합니다.');
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const Login()),
                                            (route) => false);
                                  } on FirebaseAuthException catch (e) {
                                    Navigator.pop(context);
                                    if (e.message!.contains('The password is invalid')) {
                                      ShowMessage().showToastRed('비밀번호가 틀립니다');
                                    } else {
                                      ShowMessage().showToastRed('오류가 발생하여 탈퇴에 실패했습니다');
                                    }
                                  }
                                }
                              }),
                          GestureDetector(
                            child: Container(
                                margin:
                                const EdgeInsets.all(10),
                                padding:
                                const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors
                                        .grey[350],
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                        5)),
                                child: const Text('취소',
                                    style: TextStyle(
                                        color: Colors
                                            .white,
                                        fontSize: 18))),
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