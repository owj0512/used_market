import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BannerUploader extends StatefulWidget {

  const BannerUploader({Key? key}) : super(key: key);

  @override
  State<BannerUploader> createState() => BannerUploaderState();
}

final picker = ImagePicker();

class BannerUploaderState extends State<BannerUploader> {
  final picker = ImagePicker();
  var linkUrl = []; //새로 등록한 사진 설명 변수
  static List<String> linkUrlText = []; //텍스트 컨트롤러를 텍스트로 변환해서 저장할 변수
  static List<XFile?> images = []; // 최종적으로 모든 사진들이 저장될 변수
  XFile? cameraImage; // 카메라로 촬영한 이미지를 저장할 변수
  List<XFile?> galleryImages = []; // 갤러리에서 여러장의 사진을 선택해서 저장할 변수

  @override
  void initState() {
    linkUrlText.clear();
    images.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xffF6F6F6)),
          )),
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //사진 개수. 새롭게 추가된 사진 개수와 기존 사진 개수의 합 표시
              Text('사진(${images.length}/10)', style: const TextStyle(fontSize: 16)),
              GestureDetector(
                onTap: () async {
                  galleryImages = await picker.pickMultiImage(maxHeight: 1000, maxWidth: 1000, imageQuality: 50);
                  // 사진 업로드 개수를 10개로 제한하기 위한 조건식. 이미 선택되어 있는 사진과, 갤러리에서 추가로 선택한 사진과 기존 사진 개수의 합이 10 이하여야됨
                  if (images.length + galleryImages.length <= 10) {
                    setState(() {
                      // 가져온 이미지들을 기존의 이미지와 합침
                      images.addAll(galleryImages);
                      for (int i = 0; i < galleryImages.length; i++) {
                        linkUrl.add(TextEditingController());
                        linkUrlText.add(''); //사진 개수만큼 사진 설명 리스트를 빈 문자열로 채움
                      }
                    });
                  } else {
                    if (!mounted) return;
                    showDialog(
                      useRootNavigator: false,
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('10장 까지만 등록하실 수 있습니다.', style: TextStyle(fontSize: 16)),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('확인'),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 0.5, blurRadius: 5)],
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                      Text(
                        '갤러리',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const Divider(thickness: 0.5),
          //추가한 사진을 보여주는 부분
          images.isEmpty?
              SizedBox(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.width / 2.3,
                child: DottedBorder(
                    color: Colors.grey,
                    dashPattern: const [10, 6],
                    strokeWidth: 2,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Icon(Icons.photo_camera_back, color: Colors.grey,size: 50)),
                        SizedBox(height: 8),
                        Text('이미지를 등록해주세요', style: TextStyle(color: Colors.grey))
                      ],
                    )),
              )
              :
          GridView.builder(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: images.length,
            //item 개수
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1, //1 개의 행에 보여줄 item 개수
              childAspectRatio: 21 / 9, //item 의 가로 세로의 비율
              mainAxisSpacing: 10, //수평 Padding
              crossAxisSpacing: 10, //수직 Padding
            ),
            itemBuilder: (BuildContext context, int index) {
              return GridTile(
                footer: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                    ),
                    child: Center(
                      child: TextField(
                        style: const TextStyle(fontSize: 15),
                        controller: linkUrl[index],
                        onChanged: (value) {
                          linkUrlText[index] = value.toString();
                        },
                        decoration: const InputDecoration(
                          hintText: '링크 URL',
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        ),
                      ),
                    )),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    //사진을 누르면 전체화면으로 확대해서 볼 수 있음
                    GestureDetector(
                        onTap: () => showDialog(
                            useRootNavigator: false,
                            context: context,
                            builder: (BuildContext context) => Dialog.fullscreen(
                                backgroundColor: Colors.black,
                                child: Column(
                                  children: [
                                    Flexible(
                                      child: Container(
                                          alignment: Alignment.centerRight,
                                          child: IconButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              icon: const Icon(
                                                Icons.close,
                                                color: Colors.white,
                                              ))),
                                    ),
                                    Flexible(
                                        flex: 10,
                                        fit: FlexFit.tight,
                                        child: (kIsWeb)
                                            ? Container(
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: NetworkImage(images[index]!.path),
                                                )))
                                            : Container(
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: FileImage(File(images[index]!.path)),
                                                )))),
                                  ],
                                ))),
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                    fit: BoxFit.cover, //사진을 크기를 상자 크기에 맞게 조절
                                    image: FileImage(File(images[index]!.path)))))),
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.close, color: Colors.white, size: 15),
                          onPressed: () {
                            setState(() {
                              images.removeAt(index);
                              linkUrl.removeAt(index);
                              linkUrlText.removeAt(index);
                            });
                          },
                        )),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
