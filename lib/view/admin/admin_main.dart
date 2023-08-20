import 'package:flutter/material.dart';
import 'package:used_market/view/admin/writing_management.dart';
import 'member_management.dart';


class AdminMain extends StatefulWidget {
  const AdminMain(this.tabPageIndex, {Key? key}) : super(key: key);
  final dynamic tabPageIndex;

  @override
  State<AdminMain> createState() => AdminMainState();
}

class AdminMainState extends State<AdminMain> {
  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: DefaultTabController(
        initialIndex: widget.tabPageIndex,
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('관리자 페이지', style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              ),
            ),
            bottom: const TabBar(
              labelColor: Colors.black,
              indicatorPadding: EdgeInsets.all(7),
              indicatorColor: Colors.blueAccent,
              tabs: [
                Tab(text: '회원관리'),
                Tab(text: '게시글 관리'),
              ],
            ),
          ),
          body: const TabBarView(
            physics: NeverScrollableScrollPhysics(), //탭뷰 화면 스와이프 금지
            children: [
              // 탭바1
              MemberManagement(),
              //탭바2
              WritingManagement(),
            ],
          ),
        ),
      ),
    );
  }
}
