import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NoticeController {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  //공지 글 쓰기
  Future<void> noticeWrite(String title, String content) async {
    await FirebaseFirestore.instance
        .collection('helpDesk')
        .doc('helpDesk')
        .collection('notice')
        .doc(DateTime.now().toString())
        .set({'writeDate': DateTime.now(), 'writer': uid, 'title': title, 'content': content});
  }

  Future getNotice() async {
    QuerySnapshot result = await FirebaseFirestore.instance.collection('helpDesk').doc('helpDesk').collection('notice').orderBy('writeDate', descending: true).get();
    return result;
  }

  //공지사항을 요약해서 보여주는 페이지에서 불러올 메서드. 필요한 개수만큼 보여줌
  Future getNoticeShorts(int noticeQuantity) async {
    QuerySnapshot result =
        await FirebaseFirestore.instance.collection('helpDesk').doc('helpDesk').collection('notice').orderBy('writeDate', descending: true).limit(noticeQuantity).get();
    return result;
  }

  //공지 수정을 위해 불러오는 메서드
  getNoticeForEdit(String collectionName) async{
      DocumentSnapshot result = await FirebaseFirestore.instance.collection('helpDesk').doc('helpDesk').collection('notice').doc(collectionName).get();
        return result;
  }

  //공지글 수정하기
  Future<void> noticeEdit(String collectionName, String title, String content) async {
    await FirebaseFirestore.instance
        .collection('helpDesk')
        .doc('helpDesk')
        .collection('notice')
        .doc(collectionName)
        .update({'title': title, 'content': content});
  }

  //공지 삭제
  deleteNotice(String collectionName) async {
    FirebaseFirestore.instance.collection('helpDesk').doc('helpDesk').collection('notice').doc(collectionName).delete();
  }
}
