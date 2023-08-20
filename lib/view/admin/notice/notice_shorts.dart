import 'package:flutter/material.dart';
import '../../../controller/notice/notice_controller.dart';
import 'notice_board.dart';

class NoticeShorts extends StatefulWidget {
  const NoticeShorts({Key? key, required this.noticeQuantity}) : super(key: key);
  final int noticeQuantity;

  @override
  State<NoticeShorts> createState() => NoticeShortsState();
}

class NoticeShortsState extends State<NoticeShorts> {
  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Text('공지사항', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(width: 5),
                    Icon(Icons.announcement_outlined, color: Colors.amber),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const NoticeBoard())).then((_) => setState(() {}));
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.arrow_right_outlined),
                      Text('더 보기',
                          style: TextStyle(
                            fontSize: 14,
                          )),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.black87, thickness: 0.6),
            FutureBuilder(
                future: NoticeController().getNoticeShorts(widget.noticeQuantity),
                builder: (context, AsyncSnapshot snapshot) {
                  return !snapshot.hasData
                      ? const Center(child: CircularProgressIndicator())
                      : snapshot.data.docs.length == 0
                          ? const Center(child: Text('등록된 공지사항이 없습니다', style: TextStyle(fontSize: 16)))
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                final item = snapshot.data.docs[index];
                                return ExpansionTile(
                                    backgroundColor: Colors.grey[100],
                                    tilePadding: const EdgeInsets.symmetric(horizontal: 4),
                                    childrenPadding: const EdgeInsets.only(left: 4, right: 4, top: 0, bottom: 12),
                                    expandedAlignment: Alignment.centerLeft,
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
                                        const Divider(color: Colors.grey),
                                      ],
                                    ),
                                    children: [
                                      Text(item['content']),
                                    ]);
                              });
                }),
            const Center(child: Icon(Icons.more_horiz, color: Colors.grey,)),
            const Divider(color: Colors.black87, thickness: 0.6),
          ],
        ),
      ),
    );
  }
}
