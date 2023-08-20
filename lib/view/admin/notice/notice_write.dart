import 'package:flutter/material.dart';
import '../../../component/loading.dart';
import '../../../component/on_back_pressed.dart';
import '../../../component/show_message.dart';
import '../../../controller/notice/notice_controller.dart';

class NoticeWrite extends StatefulWidget {
  const NoticeWrite({Key? key}) : super(key: key);

  @override
  State<NoticeWrite> createState() => NoticeWriteState();
}

class NoticeWriteState extends State<NoticeWrite> {
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await OnBackPressed().onBackPressed(context, '나가시겠습니까?\n입력하신 정보는 저장되지 않습니다');
        return false;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  OnBackPressed().onBackPressed(context, '나가시겠습니까?\n입력하신 정보는 저장되지 않습니다');
                },
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black)),
            title: const Text('공지사항 등록', style: TextStyle(color: Colors.black)),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(thickness: 1, color: Colors.grey[300]),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      maxLength: 100,
                      controller: title,
                      decoration: const InputDecoration(border: InputBorder.none, hintText: '제목', counterText: ''),
                      maxLines: 1,
                    ),
                  ),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      maxLength: 10000,
                      controller: content,
                      decoration: const InputDecoration(border: InputBorder.none, hintText: '내용', counterText: ''),
                      maxLines: 20,
                    ),
                  ),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  InkWell(
                    child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(5)),
                        child: const Center(
                          child: Text('등록', style: TextStyle(color: Colors.white, fontSize: 18)),
                        )),
                    onTap: () {
                      showDialog(
                        useRootNavigator: false,
                        context: context,
                        builder: (buildContext) => AlertDialog(
                          title: const Text('등록하시겠습니까?', style: TextStyle(fontSize: 17)),
                          actions: [
                            TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  Loading().loading(context, '등록중입니다');
                                  await NoticeController().noticeWrite(title.text, content.text);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  ShowMessage().showToastBlue('등록되었습니다');
                                },
                                child: const Text('네')),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('아니요')),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
