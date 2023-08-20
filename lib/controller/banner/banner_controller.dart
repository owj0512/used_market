import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class BannerController {
  late int bannerIndex; //배너 인덱스를 지정하기 위한 변수

  //배너 가져오기
  getBanner() async {
    var result = await FirebaseFirestore.instance.collection('mainBanner').orderBy('bannerIndex', descending: true).get();
    return result;
  }

  //배너 업로드하기
  uploadBanner(List images, List linkUrls) async {
    //배너 인덱스를 지정하기 위해 먼저 최근 번호를 가져와서, 최초등록이면 1번, 아니면 최근번호 +1을 저장함
    FirebaseFirestore.instance
        .collection('mainBanner')
        .orderBy('bannerIndex', descending: true)
        .limit(1)
        .get()
        .then((value) => value.docs.isEmpty ? bannerIndex = 1 : bannerIndex = value.docs[0].data()['bannerIndex'] + 1);

    //사진 저장
    List imageUrlList = []; //추가된 사진들의 url을 저장할 변수
    //등록할 사진이 1장 이상 있으면, 사진 개수만큼 한장씩 반복해서 올림
    if (images.isNotEmpty) {
      for (int i = 0; i < images.length; i++) {
        Uint8List bytes = await images[i].readAsBytes(); //받아온 이미지가 XFile 타입이므로 DB에 업로드하기 위해 타입을 변환함. Uint8List 타입으로 하는 이유는 웹,앱에서 모두 가능하기 때문
        final bannerImage = FirebaseStorage.instance.ref().child('mainBanner').child('${DateTime.now().toString()}.jpg');
        UploadTask uploadTask = bannerImage.putData(bytes, SettableMetadata(contentType: 'image/jpg'));
        TaskSnapshot taskSnapshot = await uploadTask;
        final imageUrl = await taskSnapshot.ref.getDownloadURL(); //저장한 사진을 나중에 읽어오기 위해 이미지 URL을 DB에 저장해야됨
        imageUrlList.add(imageUrl); //사진이 여러장일 수 있으므로, 각 사진의 URL을 리스트 변수 imageUrlList에 저장함
        //사진url 저장
        FirebaseFirestore.instance
            .collection('mainBanner')
            .doc()
            .set({'imageUrl': imageUrlList[i], 'linkUrl': linkUrls[i], 'bannerIndex': bannerIndex + i});
      }
    }
  }

  //배너 삭제
  deleteBanner(String docId, String imageUrl) async {
    FirebaseFirestore.instance
        .collection('mainBanner')
        .doc(docId)
        .delete();
    //파이어베이스 스토리지에 있는 사진 삭제.
      Reference ref = FirebaseStorage.instance.refFromURL(imageUrl);
      await ref.delete();
  }

  //배너 순서 아래로 이동
  moveDownBanner(String targetCollectionName, String lowerCollectionName, int targetIndex, int lowerIndex) {
    FirebaseFirestore.instance.collection('mainBanner').doc(targetCollectionName).update({'bannerIndex': lowerIndex});
    FirebaseFirestore.instance.collection('mainBanner').doc(lowerCollectionName).update({'bannerIndex': targetIndex});
  }

  //배너 순서 위로 이동
  moveUpBanner(String targetCollectionName, String upperCollectionName, int targetIndex, int upperIndex) {
    FirebaseFirestore.instance.collection('mainBanner').doc(targetCollectionName).update({'bannerIndex': upperIndex});
    FirebaseFirestore.instance.collection('mainBanner').doc(upperCollectionName).update({'bannerIndex': targetIndex});
  }

}
