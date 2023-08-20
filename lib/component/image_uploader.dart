import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

//이미지 업로드 위젯 컴포넌트
class ImageUploader extends StatefulWidget {
  //DB에 등록된 이미지를 수정할 경우에는 원본 데이터 변수들을 파라미터로 받음
  final originalImages;
  final originalImageDescription;
  const ImageUploader({Key? key, this.originalImages, this.originalImageDescription}) : super(key: key);

  @override
  State<ImageUploader> createState() => ImageUploaderState();
}

final picker = ImagePicker();

class ImageUploaderState extends State<ImageUploader> {
  final picker = ImagePicker();
  static var originalImages;
  var originalImageDescription = []; // 기존 사진 설명 컨트롤러 변수
  static List<String> originalImageDescriptionText = []; //텍스트 컨트롤러를 텍스트로 변환해서 저장할 변수
  var imageDescription = []; //새로 등록한 사진 설명 변수
  static List<String> imageDescriptionText = []; //텍스트 컨트롤러를 텍스트로 변환해서 저장할 변수
  static List<XFile?> images = []; // 최종적으로 모든 사진들이 저장될 변수
  static List deletedImages = []; //기존에 등록되어 있는 사진 중 사용자가 삭제한 사진의 url 목록은 해당 변수에 저장함
  XFile? cameraImage; // 카메라로 촬영한 이미지를 저장할 변수
  List<XFile?> galleryImages = []; // 갤러리에서 여러장의 사진을 선택해서 저장할 변수

  @override
  void initState() {
    originalImageDescriptionText.clear();
    imageDescriptionText.clear();
    images.clear();
    deletedImages.clear();

    //파라미터로 받은 변수를 새로운 변수에 저장함
    originalImages = widget.originalImages;
    if (widget.originalImageDescription != null) {
      for (int i = 0; i < widget.originalImageDescription.length; i++) {
        originalImageDescription.add(TextEditingController(text: widget.originalImageDescription[i]));
        originalImageDescriptionText.add(originalImageDescription[i].text);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
        top: BorderSide(color: Color(0xffF6F6F6)),
      )),
      padding: const EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 10),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //사진 개수. 새롭게 추가된 사진 개수와 기존 사진 개수의 합 표시
              Text('사진(${images.length}/10)', style: const TextStyle(fontSize: 16)),
              Row(
                children: [
                  //사진촬영 버튼. 웹에서는 표시되지 않음
                  kIsWeb
                      ? const SizedBox()
                      : GestureDetector(
                          onTap: () async {
                            //카메라로 사진을 촬영해서 image 변수에 넣음
                            cameraImage = await picker.pickImage(source: ImageSource.camera, maxWidth: 1000, maxHeight: 1000, imageQuality: 50);
                            //카메라를 켰는데 촬영하지 않고 뒤로가기를 누르면 null값이 저장되므로 images 변수에 저장하면 안됨. images 변수의 사진 개수가 10개 이상이면 추가로 저장하면 안됨
                            if (cameraImage != null) {
                              //기존의 사진 개수에서 새롭게 추가된 사진 개수를 더해서 10개 미만이어야 사진을 추가할 수 있음
                              if (images.length < 10) {
                                setState(() {
                                  images.add(cameraImage);
                                  imageDescription.add(TextEditingController()); //사진 설명 리스트 변수에 텍스트 컨트롤러 1개 추가
                                  imageDescriptionText.add(''); //사진 설명 텍스트에 빈 문자열 1개 추가
                                });
                              }
                              else {
                                if (!mounted) return;
                                  showDialog(
                                  useRootNavigator: false,
                                  context: context,
                                  builder: (context) =>
                                  AlertDialog(
                                    title: const Text('10장 까지만 등록하실 수 있습니다.', style: TextStyle(fontSize: 16)),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('확인'),
                                        onPressed: () =>
                                            Navigator.pop(context),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.lightBlueAccent,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 0.5, blurRadius: 5)],
                            ),
                            child: const Column(
                              children: [
                                Icon(
                                  Icons.add_a_photo,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                Text(
                                  '사진촬영',
                                  style: TextStyle(fontSize: 12, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                  //갤러리에서 사진 가져오기 버튼
                  GestureDetector(
                    onTap: () async {
                      galleryImages = await picker.pickMultiImage(maxHeight: 1000, maxWidth: 1000, imageQuality: 50);
                      // 사진 업로드 개수를 10개로 제한하기 위한 조건식. 이미 선택되어 있는 사진과, 갤러리에서 추가로 선택한 사진과 기존 사진 개수의 합이 10 이하여야됨
                      if (images.length + galleryImages.length <= 10) {
                        setState(() {
                          // 가지고 온 이미지들을 기존의 이미지와 합침
                          images.addAll(galleryImages);
                          for (int i = 0; i < galleryImages.length; i++) {
                            imageDescription.add(TextEditingController());
                            imageDescriptionText.add(''); //사진 개수만큼 사진 설명 리스트를 빈 문자열로 채움
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
            ],
          ),
          //수정일 경우, 원본 이미지들을 보여주는 부분. 원본 이미지가 없거나, 삭제해서 다 지워버린 경우 공간을 제거함
          if (originalImages == null || originalImages.isEmpty) ...[
            const SizedBox()
          ] else ...[
            Container(
              margin: const EdgeInsets.only(top: 25),
              child: GridView.builder(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: originalImages.length,
                //item 개수
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, //1 개의 행에 보여줄 item 개수
                  childAspectRatio: 1 / 1, //item 의 가로 세로의 비율
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
                            scrollPhysics: const BouncingScrollPhysics(),
                            style: const TextStyle(fontSize: 15),
                            controller: originalImageDescription[index],
                            onChanged: (value) {
                              originalImageDescriptionText[index] = value.toString(); //사진 설명란에 입력한 텍스트를 String으로 변환해서 저장함
                            },
                            decoration: const InputDecoration(
                              hintText: '사진 설명',
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
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                            image: NetworkImage(originalImages[index]),
                                          )))),
                                    ],
                                  ))),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(originalImages[index]))),
                          ),
                        ),
                        //삭제 버튼
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
                                  deletedImages.add(originalImages[index]); //삭제한 사진 리스트에 추가
                                  originalImages.removeAt(index); //사진 삭제
                                  originalImageDescription.removeAt(index); //사진 설명 텍스트 컨트롤러 삭제
                                  originalImageDescriptionText.removeAt(index); //사진 설명 텍스트 삭제
                                });
                              },
                            ))
                      ],
                    ),
                  );
                },
              ),
            )
          ],
          const Divider(thickness: 0.5),
          //새로 등록한 사진을 보여주는 부분
          GridView.builder(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: images.length,
            //item 개수
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, //1 개의 행에 보여줄 item 개수
              childAspectRatio: 1 / 1, //item 의 가로 세로의 비율
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
                        controller: imageDescription[index],
                        onChanged: (value) {
                          imageDescriptionText[index] = value.toString();
                        },
                        decoration: const InputDecoration(
                          hintText: '사진 설명',
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
                        child: (kIsWeb)
                            ? Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    image: DecorationImage(
                                        fit: BoxFit.cover, //사진을 크기를 상자 크기에 맞게 조절
                                        image: NetworkImage(images[index]!.path))))
                            : Container(
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
                              imageDescription.removeAt(index);
                              imageDescriptionText.removeAt(index);
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
