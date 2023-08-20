import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:used_market/view/help_desk/personal_Information.dart';
import 'package:used_market/view/help_desk/terms_and_conditions.dart';
import '../../component/input_field.dart';
import '../../component/loading.dart';
import '../../component/show_message.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var password2Controller = TextEditingController();
  var nameController = TextEditingController();
  var phoneNumberController = TextEditingController();
  var nicknameController = TextEditingController();
  dynamic _personalInformationCheck = false; //개인정보 수집 동의 체크
  dynamic _termsAndConditionsCheck = false; //이용약관 동의 체크
  bool passwordVisibility = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
      ),
      backgroundColor: Colors.grey[300],
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.assignment_add,
                  color: Colors.blueGrey,
                  size: 140,
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text('회원가입', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 20,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: InputField().inputField(
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      maxLength: 30,
                      controller: emailController,
                      decoration: const InputDecoration(border: InputBorder.none, hintText: '이메일', counterText: ''),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '이메일을 입력해주세요';
                        } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return "이메일 형식에 맞게 입력해주세요";
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: InputField().inputField(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: passwordController,
                            maxLength: 30,
                            obscureText: !passwordVisibility,
                            decoration: const InputDecoration(border: InputBorder.none, hintText: '비밀번호', counterText: ''),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '비밀번호를 입력해주세요';
                              } else if (value.length < 6) {
                                return '비밀번호를 6자 이상으로 입력해주세요';
                              }
                              return null;
                            },
                          ),
                        ),
                        passwordVisibility == false
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    passwordVisibility = !passwordVisibility;
                                  });
                                },
                                child: const Icon(Icons.visibility_outlined, color: Colors.black54))
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    passwordVisibility = !passwordVisibility;
                                  });
                                },
                                child: const Icon(Icons.visibility_off_outlined, color: Colors.black54))
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: InputField().inputField(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: password2Controller,
                            maxLength: 30,
                            obscureText: !passwordVisibility,
                            decoration: const InputDecoration(border: InputBorder.none, hintText: '비밀번호 확인', counterText: ''),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '비밀번호를 입력해주세요';
                              } else if (value != passwordController.text) {
                                return '비밀번호가 다릅니다';
                              }
                              return null;
                            },
                          ),
                        ),
                        passwordVisibility == false
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    passwordVisibility = !passwordVisibility;
                                  });
                                },
                                child: const Icon(Icons.visibility_outlined, color: Colors.black54))
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    passwordVisibility = !passwordVisibility;
                                  });
                                },
                                child: const Icon(Icons.visibility_off_outlined, color: Colors.black54))
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: InputField().inputField(
                    TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      maxLength: 20,
                      decoration: const InputDecoration(border: InputBorder.none, hintText: "이름", counterText: ''),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '이름을 입력해주세요';
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: InputField().inputField(
                    TextFormField(
                      controller: phoneNumberController,
                      keyboardType: TextInputType.phone,
                      maxLength: 20,
                      decoration: const InputDecoration(border: InputBorder.none, hintText: "전화번호  ( - 제외)", counterText: ''),
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
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: InputField().inputField(
                    TextFormField(
                      controller: nicknameController,
                      keyboardType: TextInputType.text,
                      maxLength: 20,
                      decoration: const InputDecoration(border: InputBorder.none, hintText: "닉네임", counterText: ''),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '닉네임을 입력해주세요';
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                //개인정보 수집 동의 체크
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  width: 550,
                  child: Row(
                    children: [
                      Checkbox(
                          visualDensity: VisualDensity.compact,
                          value: _personalInformationCheck,
                          onChanged: (value) {
                            setState(() {
                              _personalInformationCheck = value;
                            });
                          }),
                      GestureDetector(
                          child: const Text('[필수] 개인정보 수집·이용 동의'),
                          onTap: () {
                            setState(() {
                              _personalInformationCheck = !_personalInformationCheck;
                            });
                          }),
                      GestureDetector(
                          child: const Text(' [내용보기]', style: TextStyle(color: Colors.blue)),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const PersonalInformation()));
                          }),
                    ],
                  ),
                ),

                //이용약관 동의 체크
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  width: 550,
                  child: Row(
                    children: [
                      Checkbox(
                          visualDensity: VisualDensity.compact,
                          value: _termsAndConditionsCheck,
                          onChanged: (value) {
                            setState(() {
                              _termsAndConditionsCheck = value;
                            });
                          }),
                      GestureDetector(
                          child: const Text('[필수] 이용약관 동의'),
                          onTap: () {
                            setState(() {
                              _termsAndConditionsCheck = !_termsAndConditionsCheck;
                            });
                          }),
                      GestureDetector(
                          child: const Text(' [내용보기]', style: TextStyle(color: Colors.blue)),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => TermsAndConditions()));
                          }),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                //회원가입 버튼
                GestureDetector(
                  onTap: () async {
                    //텍스트필드 유효성 검증
                    if (_formKey.currentState!.validate()) {
                      if (_personalInformationCheck == false || _termsAndConditionsCheck == false) {
                        ShowMessage().showToastRed('필수 항목에 체크하세요');
                      } else {
                        try {
                          //로딩창을 먼저 띄움
                          Loading().loading(context, '처리 중입니다');
                          //파이어베이스에 등록
                          UserCredential userCredential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);
                          //가입한 유저의 정보를 user 변수에 저장함
                          User user = FirebaseAuth.instance.currentUser!;
                          //가입인증 메일 발송
                          await user.sendEmailVerification();
                          //파이어베이스 DB 사용자정보에 저장
                          await FirebaseFirestore.instance.collection('memberInfo').doc(user.uid).set({
                            'registeredDate': DateTime.now(),
                            'email': user.email.toString(),
                            'name': nameController.text,
                            'phoneNumber': phoneNumberController.text,
                            'nickname': nicknameController.text,
                            'memberGrade': 1,
                          });
                          //로그인페이지로 돌아가서 완료 메시지를 띄움
                          if (!mounted) return;
                          Navigator.pop(context);
                          Navigator.pop(context);
                          ShowMessage().showSnackBarBlue(context, '회원가입이 완료되었습니다. 가입하신 이메일 주소로 발송된 메일을 확인하고 인증 후 로그인해주시기 바랍니다.');
                          //에러 발생시 처리
                        } on FirebaseAuthException catch (e) {
                          Navigator.pop(context);
                          String errorMessage = '';
                          if (e.message!.contains('The email address is already in use by another account')) {
                            errorMessage = '이미 등록된 이메일 주소입니다';
                          } else {
                            errorMessage = e.message.toString();
                          }
                          ShowMessage().showToastRed(errorMessage);
                        }
                      }
                    }
                  },
                  child: SizedBox(
                    width: 595,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(12)),
                        child: const Center(
                          child: Text(
                            '회원가입 신청',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('이미 가입한 회원이세요?'),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        ' 로그인 페이지로 이동합니다',
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
