import 'package:flutter/material.dart';
import 'notice/notice_shorts.dart';

//공지사항, 문의내역 등 관리
class WritingManagement extends StatefulWidget {
  const WritingManagement({Key? key}) : super(key: key);

  @override
  State<WritingManagement> createState() => WritingManagementState();
}

class WritingManagementState extends State<WritingManagement> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          NoticeShorts(noticeQuantity: 3),
        ],
      )

    );
  }
}
