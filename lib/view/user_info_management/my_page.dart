import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:used_market/controller/member_info/member_info_controller.dart';
import 'package:used_market/view/admin/admin_main.dart';
import 'package:used_market/view/admin/banner_management/banner_management.dart';
import 'package:used_market/home/home.dart';
import 'package:used_market/view/user_info_management/email_change.dart';
import 'package:used_market/view/user_info_management/my_info_edit.dart';
import 'package:used_market/view/user_info_management/password_change.dart';
import 'package:used_market/view/user_info_management/withdrawal.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => MyPageState();
}

class MyPageState extends State<MyPage> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  User user = FirebaseAuth.instance.currentUser!;
  dynamic item;
  XFile? cameraImage; // 카메라로 촬영한 이미지를 저장할 변수
  XFile? galleryImage; // 갤러리에서 가져온 이미지를 저장할 변수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: MemberInfoController().getUserInfo(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              item = snapshot.data as Map;
            } else {
              null;
            }
            return !snapshot.hasData
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Center(
                      child: Container(
                        width: 800,
                        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                        child: Column(
                          children: [
                            (kIsWeb) ? const SizedBox() : const SizedBox(height: 50),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //프로필 사진
                                Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Container(
                                      width: 90,
                                      height: 90,
                                      margin: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: item.containsKey('profilePhotoUrl')
                                              ? DecorationImage(fit: BoxFit.fill, image: NetworkImage(item['profilePhotoUrl']))
                                              : const DecorationImage(fit: BoxFit.fill, image: AssetImage('assets/images/profile.png'))),
                                    ),
                                    PopupMenuButton(
                                      icon: CircleAvatar(
                                        maxRadius: 14,
                                        backgroundColor: Colors.grey[50],
                                        child: const Icon(Icons.camera_alt, size: 18, color: Colors.grey),
                                      ),
                                      itemBuilder: (context) {
                                        return [
                                          const PopupMenuItem(value: 'camera', child: Text('카메라로 촬영하기')),
                                          const PopupMenuItem(value: 'gallery', child: Text('갤러리에서 가져오기')),
                                          if (item.containsKey('profilePhotoUrl')) ...[
                                            const PopupMenuItem(value: 'delete', child: Text('프로필 사진 삭제')),
                                          ] else
                                            ...[]
                                        ];
                                      },
                                      onSelected: (value) async {
                                        switch (value) {
                                          case 'camera':
                                            cameraImage = await ImagePicker()
                                                .pickImage(source: ImageSource.camera, maxWidth: 1000, maxHeight: 1000, imageQuality: 50);
                                            if (cameraImage != null) {
                                              MemberInfoController().uploadProfilePhoto(cameraImage).then((value) => setState(() {}));
                                            }
                                            break;

                                          case 'gallery':
                                            galleryImage = await ImagePicker()
                                                .pickImage(source: ImageSource.gallery, maxWidth: 1000, maxHeight: 1000, imageQuality: 50);
                                            if (galleryImage != null) {
                                              MemberInfoController().uploadProfilePhoto(galleryImage).then((value) => setState(() {}));
                                            }
                                            break;

                                          case 'delete':
                                            setState(() {
                                              MemberInfoController().deleteProfilePhoto(item['profilePhotoUrl']);
                                            });
                                            break;
                                        }
                                      },
                                    )
                                  ],
                                ),
                                Container(
                                    margin: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              item['nickname'],
                                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(width: 12),
                                            HomeState.memberGradeCode == 1
                                                ? const Row(
                                                    children: [
                                                      Icon(Icons.stars, color: Colors.grey, size: 22),
                                                      Text('실버회원', style: TextStyle(fontSize: 16))
                                                    ],
                                                  )
                                                : HomeState.memberGradeCode == 2
                                                    ? const Row(
                                                        children: [
                                                          Icon(Icons.stars, color: Colors.amberAccent, size: 22),
                                                          Text('골드회원', style: TextStyle(fontSize: 16))
                                                        ],
                                                      )
                                                    : HomeState.memberGradeCode == 3
                                                        ? const Row(
                                                            children: [
                                                              Icon(Icons.stars, color: Colors.cyan, size: 22),
                                                              Text('프리미엄회원', style: TextStyle(fontSize: 16))
                                                            ],
                                                          )
                                                        : const Row(
                                                            children: [
                                                              Icon(Icons.vpn_key_rounded, color: Colors.amber, size: 22),
                                                              Text('관리자', style: TextStyle(fontSize: 16))
                                                            ],
                                                          )
                                          ],
                                        ),
                                        Text(
                                          item['name'] + ' ' + '님',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          user.email.toString(),
                                          style: const TextStyle(fontSize: 15, color: Colors.black54),
                                        ),
                                        Text(
                                          item['phoneNumber'],
                                          style: const TextStyle(fontSize: 15, color: Colors.black54),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                            const Divider(thickness: 1),
                            Container(
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.all(8),
                                child: const Text('마이 리스트', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.sell_outlined, size: 28),
                                      TextButton(
                                          child: const Text('판매 등록한 물품', style: TextStyle(fontSize: 16, color: Colors.black)),
                                          onPressed: () {
                                            //Navigator.push(context, MaterialPageRoute(builder: (context) => ));
                                          })
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.all(8),
                                child: const Text('회원정보', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.mail_outline, size: 30),
                                      TextButton(
                                          child: const Text('이메일 주소 변경', style: TextStyle(fontSize: 16, color: Colors.black)),
                                          onPressed: () {
                                            EmailChange().emailChange(context);
                                          }),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.enhanced_encryption_outlined, size: 30),
                                      TextButton(
                                          child: const Text('비밀번호 변경', style: TextStyle(fontSize: 16, color: Colors.black)),
                                          onPressed: () {
                                            PasswordChange().passwordChange(context);
                                          }),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.edit_note_sharp, size: 30),
                                      TextButton(
                                          child: const Text('내 정보 수정', style: TextStyle(fontSize: 16, color: Colors.black)),
                                          onPressed: () async {
                                            var result = await FirebaseFirestore.instance.collection('memberInfo').doc(uid).get();
                                            var data = result.data() as Map;
                                            MyInfoEditState.originalData['name'] = data['name'];
                                            MyInfoEditState.originalData['phoneNumber'] = data['phoneNumber'];
                                            MyInfoEditState.originalData['nickname'] = data['nickname'];
                                            if (!mounted) return;
                                            showDialog(
                                                useRootNavigator: false,
                                                context: context,
                                                builder: (BuildContext context) => const MyInfoEdit()).then((value) => setState(() {}));
                                          }),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      //회원탈퇴 버튼
                                      const Icon(Icons.output, size: 30),
                                      TextButton(
                                          child: const Text('회원탈퇴', style: TextStyle(fontSize: 16, color: Colors.black)),
                                          onPressed: () {
                                            Withdrawal().withdrawal(context);
                                          })
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),

                            //관리자 계정일 경우 관리자 페이지 메뉴를 표시
                            HomeState.memberGradeCode != 9
                                ? const SizedBox()
                                : Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.yellow[100]),
                                    child: Column(
                                      children: [
                                        //Divider(thickness: 1),
                                        Container(
                                            alignment: Alignment.centerLeft,
                                            margin: const EdgeInsets.all(8),
                                            child: const Text('관리자 페이지', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(Icons.people_rounded, size: 30),
                                                  TextButton(
                                                      child: const Text('회원관리', style: TextStyle(fontSize: 16, color: Colors.black)),
                                                      onPressed: () {
                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminMain(0)));
                                                      })
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(Icons.list_alt_outlined, size: 30),
                                                  TextButton(
                                                      child: const Text('게시글 관리', style: TextStyle(fontSize: 16, color: Colors.black)),
                                                      onPressed: () {
                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminMain(1)));
                                                      })
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(Icons.featured_play_list_outlined, size: 30),
                                                  TextButton(
                                                      child: const Text('배너 관리', style: TextStyle(fontSize: 16, color: Colors.black)),
                                                      onPressed: () {
                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const BannerManagement()));
                                                      })
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  );
          }),
    );
  }
}
