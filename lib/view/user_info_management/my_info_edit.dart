import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../component/input_field.dart';
import '../../component/loading.dart';
import '../../component/show_message.dart';

class MyInfoEdit extends StatefulWidget {
  const MyInfoEdit({Key? key}) : super(key: key);

  @override
  State<MyInfoEdit> createState() => MyInfoEditState();
}

class MyInfoEditState extends State<MyInfoEdit> {
  //DB에 저장된 기존 데이터를 초기값으로 보여주기 위해 static 변수로 선언함
  static Map<dynamic, dynamic> originalData = {'name': '', 'phoneNumber': '', 'nickname': ''};
  final _formKey = GlobalKey<FormState>(); //텍스트필드 유효성 검증을 위한 변수
  var nameController = TextEditingController(text: originalData['name']);
  var phoneNumberController = TextEditingController(text: originalData['phoneNumber']);
  var nicknameController = TextEditingController(text: originalData['nickname']);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Dialog(
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('내 정보 수정', style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('이름', style: TextStyle(fontSize: 16, color: Colors.black)),
                  InputField().inputField(
                    TextFormField(
                      controller: nameController,
                      maxLength: 30,
                      decoration: const InputDecoration(border: InputBorder.none, counterText: ''),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '이름을 입력해주세요';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Text('전화번호', style: TextStyle(fontSize: 16, color: Colors.black)),
                  InputField().inputField(
                    TextFormField(
                      controller: phoneNumberController,
                      maxLength: 20,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(border: InputBorder.none, counterText: ''),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '전화번호를 입력해주세요';
                        } else if (value.contains('-')) {
                          return '-를 제외하고 숫자만 입력해주세요';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Text('닉네임', style: TextStyle(fontSize: 16, color: Colors.black)),
                  InputField().inputField(
                    TextFormField(
                      controller: nicknameController,
                      maxLength: 20,
                      decoration: const InputDecoration(border: InputBorder.none, counterText: ''),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '닉네임을 입력해주세요';
                        }
                        return null;
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    //mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                          child: Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5)),
                              child: const Text('변경', style: TextStyle(color: Colors.white, fontSize: 18))),
                          //변경 버튼을 눌렀을 때
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                //로딩창을 먼저 띄움
                                Loading().loading(context, '처리 중입니다');
                                //파이어베이스에 등록
                                //파이어베이스 DB 사용자정보에 저장
                                User user = FirebaseAuth.instance.currentUser!;
                                await FirebaseFirestore.instance.collection('memberInfo').doc(user.uid).update({
                                  'name': nameController.text,
                                  'phoneNumber': phoneNumberController.text,
                                  'nickname': nicknameController.text,
                                });
                                //로그인페이지로 돌아가서 완료 메시지를 띄움
                                if (!mounted) return;
                                Navigator.pop(context);
                                Navigator.pop(context);
                                ShowMessage().showSnackBarBlue(context, '내 정보 수정이 완료되었습니다');
                                //에러 발생시 처리
                              } on FirebaseAuthException catch (e) {
                                Navigator.pop(context);
                                ShowMessage().showSnackBarRed(context, e.message.toString());
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
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
