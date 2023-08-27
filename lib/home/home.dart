import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:used_market/model/member/member_grade.dart';
import 'package:used_market/view/admin/notice/notice_shorts.dart';
import 'package:used_market/home/main_banner.dart';
import 'package:used_market/view/user_info_management/login.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  static int memberGradeCode = 1; // 회원 등급 코드
  static String memberGrade = ''; // 회원 등급

  @override
  void initState() {
    getMemberGrade();
    super.initState();
  }

  //회원등급을 가져오는 메서드
  getMemberGrade() async {
    var result = await FirebaseFirestore.instance.collection('memberInfo').doc(FirebaseAuth.instance.currentUser!.uid).get();
    memberGradeCode = result.data()!['memberGrade'];
    memberGrade = MemberGrade().memberGrade[memberGradeCode]!;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/logo_title.png', scale: 7.0),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.black87,
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('로그아웃 하시겠습니까?', style: TextStyle(fontSize: 16)),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('네'),
                          onPressed: () async {
                            await const FlutterSecureStorage().delete(key: 'login');
                            FirebaseAuth.instance.signOut();
                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Login()), (route) => false);
                          },
                        ),
                        TextButton(
                          child: const Text('아니요'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    );
                  });
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.0),
          child: MainBanner(),
        ),
        const SizedBox(height: 8.0),
        const NoticeShorts(noticeQuantity: 3),

        TextButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MainBanner()));
        }, child: Text('테스트'))

          ],
        ),
      ),
    );
  }
}
