import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:used_market/component/input_field.dart';
import 'package:used_market/component/loading.dart';
import 'package:used_market/component/show_message.dart';
import 'package:used_market/view/help_desk/privacy_policy.dart';
import 'package:used_market/view/help_desk/terms_and_conditions.dart';
import 'package:used_market/home/main_tab_page.dart';
import 'package:used_market/view/user_info_management/email_change.dart';
import 'package:used_market/view/user_info_management/password_find.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:used_market/view/user_info_management/sign_up.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  dynamic userInfo = ''; //로그인 상태 유지에 체크한 유저의 정보는 userInfo 변수에 저장함
  static const storage = FlutterSecureStorage(); //로그인 상태 유지 기능을 사용하기 위한 변수
  dynamic _loginMaintain = false; //로그인 상태 유지 체크 여부
  bool passwordVisibility = false;

  @override
  void initState() {
    super.initState();
    //로그인 상태 유지 여부를 확인하기 위해 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  //로그인 상태 유지 여부 확인 메서드
  _asyncMethod() async {
    userInfo = await storage.read(key: 'login');
    if (userInfo != null && FirebaseAuth.instance.currentUser != null) {
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainTabPage()), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Image.asset('assets/images/logo_main.png', scale: 3.0),
                  const SizedBox(height: 20),
                  const Text('스마트 중고물품 거래 플랫폼', style: TextStyle(fontSize: 20, color: Colors.black54, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: InputField().inputField(
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        maxLength: 30,
                        decoration: const InputDecoration(border: InputBorder.none, hintText: '이메일 주소', counterText: ''),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '이메일을 입력해주세요';
                            //이메일 형식 검증코드
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
                              obscureText: !passwordVisibility,
                              maxLength: 30,
                              decoration: const InputDecoration(border: InputBorder.none, hintText: '비밀번호', counterText: ''),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '비밀번호를 입력해주세요';
                                }
                                return null;
                              },
                            ),
                          ),
                          //패스워드 보여주기/가리기 버튼
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
                  //로그인 상태 유지 체크박스
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    width: 550,
                    child: Row(
                      children: [
                        Checkbox(
                            visualDensity: VisualDensity.compact,
                            value: _loginMaintain,
                            onChanged: (value) {
                              setState(() {
                                _loginMaintain = value;
                              });
                            }),
                        GestureDetector(
                            child: const Text('로그인 상태 유지'),
                            onTap: () {
                              setState(() {
                                _loginMaintain = !_loginMaintain;
                              });
                            })
                      ],
                    ),
                  ),
                  //로그인 버튼
                  InkWell(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          Loading().loading(context, '로그인 중입니다');
                          //로그인 메서드 실행
                          UserCredential result =
                              await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
                          //사용자가 이메일 인증을 하면, 즉시 반영되지 않으므로 reload 해줘야 됨
                          await FirebaseAuth.instance.currentUser!.reload();
                          //사용자가 이메일 인증을 했는지 확인
                          if (FirebaseAuth.instance.currentUser!.emailVerified) {
                            //로그인 상태 유지 체크했을 때 로그인이 유지되도록 하는 코드
                            if (_loginMaintain == true) {
                              await storage.write(key: 'login', value: 'email${emailController.text}password ${passwordController.text}');
                            }
                            //최종적으로 로그인 성공 했을 때. 현재 페이지를 스택에서 지우고 메인페이지로 이동
                            if (!mounted) return;
                              Navigator.pop(context);
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainTabPage()), (route) => false);
                          }
                          //이메일 인증이 되지 않은 유저에 대한 처리
                          else {
                            if (!mounted) return;
                            Navigator.pop(context);
                            showDialog(
                                useRootNavigator: false,
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: const Column(
                                        children: [
                                          Text('이메일 인증이 완료되지 않았습니다', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                                          SizedBox(height: 10),
                                          Text('발송된 이메일을 확인하고 인증 후 로그인하여 주시기 바랍니다. 메일이 수신되지 않았을 경우 스팸메일함을 확인해보시고, 없으면 아래 인증메일 재발송 버튼을 눌러주세요',
                                              style: TextStyle(fontSize: 15)),
                                        ],
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('인증메일 재발송'),
                                          onPressed: () {
                                            //회원가입 인증 메일 발송
                                            FirebaseAuth.instance.currentUser?.sendEmailVerification();
                                            Navigator.pop(context);
                                            ShowMessage().showToastBlue('인증메일이 재발송 되었습니다. 메일이 수신되지 않을 경우 스팸메일함을 확인해주세요');
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('닫기'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ));
                          }
                        } on FirebaseAuthException catch (e) {
                          String errorMessage = '';
                          //파이어베이스 로그인 실패 시 예외 처리
                          if (e.message!.contains('There is no user record corresponding to this identifier')) {
                            errorMessage = '등록되지 않은 사용자입니다. 회원가입 후 사용해주세요';
                          } else if (e.message!.contains('The password is invalid or the user does not have a password')) {
                            errorMessage = '비밀번호가 틀립니다';
                          } else {
                            errorMessage = e.message!;
                          }
                          Navigator.pop(context);
                          ShowMessage().showToastRed(errorMessage);
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        width: 550,
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(12)),
                        child: const Center(
                          child: Text(
                            '로그인',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => EmailChange().emailChange(context),
                        child: const Text('이메일 변경', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(
                          height: 15,
                          child: VerticalDivider(
                            color: Colors.blue,
                            thickness: 1.5,
                          )),
                      GestureDetector(
                        onTap: () => PasswordFind().passwordFind(context),
                        child: const Text('비밀번호 찾기', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(
                          height: 15,
                          child: VerticalDivider(
                            color: Colors.blue,
                            thickness: 1.5,
                          )),
                      GestureDetector(
                        child: const Text(
                          ' 회원가입',
                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUp())),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TermsAndConditions())),
                        child: const Text('[이용약관]', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyPolicy())),
                        child: const Text('[개인정보 처리방침]', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
