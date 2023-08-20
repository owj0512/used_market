import 'package:flutter/material.dart';
import '../../../controller/notice/notice_controller.dart';
import '../../../home/home.dart';
import 'notice_edit.dart';
import 'notice_write.dart';

class NoticeBoard extends StatefulWidget {
  const NoticeBoard({Key? key}) : super(key: key);

  @override
  State<NoticeBoard> createState() => NoticeBoardState();
}

class NoticeBoardState extends State<NoticeBoard> {
  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black)),
          title: const Row(
            children: [
              Text('공지사항 ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              Icon(Icons.announcement_outlined, color: Colors.amber),
            ],
          ),
          actions: [
            HomeState.memberGradeCode == 9
                ? TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const NoticeWrite())).then((_) => setState(() {}));
                    },
                    child: const Text('등록', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)))
                : const SizedBox(),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: FutureBuilder(
              future: NoticeController().getNotice(),
              builder: (context, AsyncSnapshot snapshot) {
                return !snapshot.hasData
                    ? const Center(child: CircularProgressIndicator())
                    : snapshot.data.docs.length == 0
                        ? const Center(child: Text('등록된 공지사항이 없습니다', style: TextStyle(fontSize: 16)))
                        : ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              final item = snapshot.data.docs[index];
                              return ExpansionTile(
                                  initiallyExpanded: false,
                                  backgroundColor: Colors.grey[100],
                                  tilePadding: const EdgeInsets.symmetric(horizontal: 4),
                                  childrenPadding: const EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 8),
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['title'],
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(item['writeDate'].toDate().toString().substring(0, 16),
                                          style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                      const Divider(),
                                    ],
                                  ),
                                  children: [
                                    Align(alignment: Alignment.centerLeft, child: Text(item['content'])),
                                    const SizedBox(height: 10),
                                    //수정, 삭제 부분. 관리자에게만 보임
                                    HomeState.memberGradeCode == 9
                                        ? Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => NoticeEdit(collectionName: item.id)))
                                                      .then((_) => setState(() {}));
                                                },
                                                child: Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: const BorderRadius.all(Radius.circular(3)),
                                                        border: Border.all(color: Colors.black)),
                                                    child: const Text('수정')),
                                              ),
                                              const SizedBox(width: 8),

                                              //삭제 버튼
                                              GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (buildContext) => AlertDialog(
                                                            title: const Text('삭제하시겠습니까?', style: TextStyle(fontSize: 16)),
                                                            actions: [
                                                              TextButton(
                                                                  onPressed: () {
                                                                    Navigator.pop(context);
                                                                    setState(() {
                                                                      NoticeController().deleteNotice(item.id);
                                                                    });
                                                                  },
                                                                  child: const Text('네')),
                                                              TextButton(
                                                                  onPressed: () {
                                                                    Navigator.pop(context);
                                                                  },
                                                                  child: const Text('아니요')),
                                                            ],
                                                          ));
                                                },
                                                child: Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: const BorderRadius.all(Radius.circular(3)),
                                                        border: Border.all(color: Colors.black)),
                                                    child: const Text('삭제')),
                                              ),
                                            ],
                                          )
                                        : const SizedBox(),
                                  ]);
                            });
              }),
        ),
      ),
    );
  }
}
