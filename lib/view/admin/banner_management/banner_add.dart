import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:used_market/component/banner_uploader.dart';
import 'package:used_market/component/loading.dart';
import 'package:used_market/component/show_message.dart';
import 'package:used_market/controller/banner/banner_controller.dart';

class BannerAdd extends StatefulWidget {
  const BannerAdd({Key? key}) : super(key: key);

  @override
  State<BannerAdd> createState() => BannerAddState();
}

class BannerAddState extends State<BannerAdd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          title: const Text('배너 등록'),
        ),
        body: const Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
              child: BannerUploader()),
        ),
        bottomNavigationBar: InkWell(
          onTap: () {
            if (BannerUploaderState.images.isNotEmpty) {
              showDialog(
                  useRootNavigator: false,
                  context: context,
                  builder: (buildContext) => AlertDialog(
                        title: const Text('등록하시겠습니까?', style: TextStyle(fontSize: 16)),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('네'),
                            onPressed: () async {
                              //팝업창을 닫고 로딩 팝업창을 띄움
                              Navigator.pop(context);
                              Loading().loading(context, '등록중입니다');
                              await BannerController().uploadBanner(
                                BannerUploaderState.images,
                                BannerUploaderState.linkUrlText,
                              );
                              if (!mounted) return;
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: const Text('아니요'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ));
            } else {
              ShowMessage().showToastRed('선택된 사진이 없습니다.');
            }
          },
          child: Container(
              margin: const EdgeInsets.all(6),
              width: 600,
              height: 50,
              decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(6)),
              child: const Center(child: Text('등록', style: TextStyle(fontSize: 20, color: Colors.white)))),
        ),
      ),
    );
  }
}
