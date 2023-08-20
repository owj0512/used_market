import 'package:flutter/material.dart';
import 'package:used_market/component/show_message.dart';
import 'package:used_market/controller/banner/banner_controller.dart';
import 'package:used_market/view/admin/banner_management/banner_add.dart';

class BannerManagement extends StatefulWidget {
  const BannerManagement({Key? key}) : super(key: key);

  @override
  State<BannerManagement> createState() => BannerManagementState();
}

class BannerManagementState extends State<BannerManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('배너 관리'),
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  FutureBuilder(
                      future: BannerController().getBanner(),
                      builder: (context, AsyncSnapshot snapshot) {
                        return !snapshot.hasData
                            ? const Center(child: CircularProgressIndicator())
                            : snapshot.data.docs.length == 0
                                ? const Center(child: Text('등록된 배너가 없습니다'))
                                : ListView.builder(
                                    physics: const ScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder: (context, index) {
                                      final item = snapshot.data.docs[index];
                                      return Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Container(
                                                height: MediaQuery.of(context).size.width / 2.6,
                                                margin: const EdgeInsets.symmetric(vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius: BorderRadius.circular(5),
                                                  image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(item['imageUrl'])),
                                                )),
                                          ),
                                          SizedBox(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                //삭제 버튼
                                                IconButton(
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) => AlertDialog(
                                                                title: const Text('삭제하시겠습니까?', style: TextStyle(fontSize: 16)),
                                                                actions: <Widget>[
                                                                  TextButton(
                                                                    child: const Text('네'),
                                                                    onPressed: () {
                                                                      setState(() {
                                                                        BannerController().deleteBanner(item.id, item['imageUrl']);
                                                                        Navigator.pop(context);
                                                                      });
                                                                    },
                                                                  ),
                                                                  TextButton(
                                                                      child: const Text('아니요'),
                                                                      onPressed: () {
                                                                        Navigator.pop(context);
                                                                      }),
                                                                ],
                                                              ));
                                                    },
                                                    padding: const EdgeInsets.all(8),
                                                    constraints: const BoxConstraints(),
                                                    icon: const Icon(Icons.delete_outline, size: 28)),

                                                //위로 이동 버튼
                                                IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        if (index != 0) {
                                                          BannerController().moveUpBanner(item.id, snapshot.data.docs[index - 1].id, item['bannerIndex'],
                                                              snapshot.data.docs[index - 1]['bannerIndex']);
                                                          ShowMessage().showToastBlue('배너 순서가 변경되었습니다');
                                                        } else {
                                                          null;
                                                        }
                                                      });
                                                    },
                                                    padding: const EdgeInsets.all(8),
                                                    constraints: const BoxConstraints(),
                                                    icon: const Icon(Icons.keyboard_arrow_up, size: 28)),

                                                //'아래로 이동' 버튼
                                                IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        //가장 아래 배너인지 확인
                                                        if (index != snapshot.data.docs.length - 1) {
                                                          BannerController().moveDownBanner(item.id, snapshot.data.docs[index + 1].id,
                                                              item['bannerIndex'], snapshot.data.docs[index + 1]['bannerIndex']);
                                                          ShowMessage().showToastBlue('배너 순서가 변경되었습니다');
                                                        } else {
                                                          null;
                                                        }
                                                      });
                                                    },
                                                    padding: const EdgeInsets.all(8),
                                                    constraints: const BoxConstraints(),
                                                    icon: const Icon(Icons.keyboard_arrow_down, size: 28)),
                                              ],
                                            ),
                                          )
                                        ],
                                      );
                                    });
                      }),
                  const SizedBox(height: 60),
                ],
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const BannerAdd())).then((value) => setState(() {}));
          },
          child: const Icon(Icons.add)),
    );
  }
}
