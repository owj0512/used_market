import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:used_market/component/show_message.dart';
import 'package:used_market/model/member/member_grade.dart';

//전체 회원 목록 페이지
class MemberManagement extends StatefulWidget {
  const MemberManagement({Key? key}) : super(key: key);

  @override
  State<MemberManagement> createState() => MemberManagementState();
}

class MemberManagementState extends State<MemberManagement> {
  //파이어베이스 DB에서 전체 회원 목록을 가져오는 메서드
  Future getMemberList() async {
    QuerySnapshot result = await FirebaseFirestore.instance.collection('memberInfo').orderBy('registeredDate', descending: true).get();
    return result;
  }

  List<String> memberGradeList = ['실버회원', '골드회원', '프리미엄회원', '관리자'];
  String? memberGrade;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: FutureBuilder(
                future: getMemberList(),
                builder: (context, AsyncSnapshot snapshot) {
                  return !snapshot.hasData
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        final item = snapshot.data.docs[index];
                        return Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.grey[100]),
                            //회원 정보를 보여주는 부분. 접기 펼치기가 되는 위젯 사용
                            child: ExpansionTile(
                              //회원 정보 간략히 보기
                              title: Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    color: Colors.black54,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item['email'],
                                          style: const TextStyle(fontSize: 16),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          item['name'],
                                          style: const TextStyle(fontSize: 16),
                                          overflow: TextOverflow.ellipsis,
                                        ),

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              expandedAlignment: Alignment.centerLeft,
                              //회원 정보 상세 보기(펼치기)
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 15, bottom: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('이름: ${item['name']}', style: const TextStyle(fontSize: 18)),
                                      Row(
                                        children: [
                                          Text('회원등급: ${MemberGrade().memberGrade[item['memberGrade']]!}', style: const TextStyle(fontSize: 18)),
                                          //변경 버튼. 회원 등급을 변경하기 위한 다이얼로그를 띄워줌
                                          GestureDetector(
                                              onTap: () {
                                                memberGradeChange(
                                                    context, item.id, item['name'], MemberGrade().memberGrade[item['memberGrade']]!);
                                              },
                                              child: const Text(
                                                ' [변경]',
                                                style: TextStyle(color: Colors.blue),
                                              )),
                                        ],
                                      ),
                                      Text('이메일: ${item['email']}', style: const TextStyle(fontSize: 18)),
                                      Text('전화번호: ${item['phoneNumber']}', style: const TextStyle(fontSize: 18)),
                                      Text('가입일: ${item['registeredDate'].toDate().toString().substring(0, 16)}',
                                          style: const TextStyle(fontSize: 18)),
                                    ],
                                  ),
                                ),
                              ],
                            ));
                      });
                })));
  }

  //회원 등급 변경을 눌렀을 때 띄워주는 다이얼로그
  memberGradeChange(context, String uid, String userName, String currentGrade) {
    showDialog(
        useRootNavigator: false,
        context: context,
        builder: (buildContext) => Dialog(
            child: Container(
                width: 400,
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //기존 등급
                        Text(currentGrade, style: const TextStyle(fontSize: 18)),
                        const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.arrow_right_alt),
                        ),
                        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            //변경할 등급. 드롭다운 메뉴에서 선택
                            child: DropdownButton(
                              hint: const Text('선택'),
                              isDense: true,
                              alignment: Alignment.center,
                              underline: const SizedBox.shrink(),
                              value: memberGrade,
                              items: memberGradeList.map((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (dynamic value) {
                                setState(() {
                                  memberGrade = value;
                                });
                              },

                            ),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //변경 버튼을 눌렀을 때 DB에 저장
                        GestureDetector(
                          onTap: () async {
                            if (memberGrade == null) {
                              ShowMessage().showToastRed('변경하실 회원등급을 선택해주세요');
                            } else {
                              Navigator.pop(context);
                              await FirebaseFirestore.instance.collection('memberInfo').doc(uid).update({
                                'memberGrade': MemberGrade().memberGradeCode[memberGrade]!,
                              });

                            }
                          },
                          child: Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5)),
                              child: const Text('변경', style: TextStyle(color: Colors.white, fontSize: 18))),

                        ),
                        //취소 버튼
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                              decoration: BoxDecoration(color: Colors.grey[350], borderRadius: BorderRadius.circular(5)),
                              child: const Text('취소', style: TextStyle(color: Colors.white, fontSize: 18))),

                        ),
                      ],
                    )
                  ],
                )))).then((_) => setState(() {}));  //다이얼로그 창을 닫으면 rebuild
  }
}
