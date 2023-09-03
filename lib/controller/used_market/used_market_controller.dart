import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UsedMarketController {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  //물품 상세정보 가져오기
  Future getGoodsInfo(String docId) async{
    var result = await FirebaseFirestore.instance.collection('usedMarket').doc(docId).get();
    return result.data();
  }

  //물품 리스트 가져오기
  Future getGoodsList(String keyword) async{
      var result = keyword.isEmpty?
          await FirebaseFirestore.instance.collection('usedMarket').orderBy('registeredDate', descending: true).get()
      :
      await FirebaseFirestore.instance.collection('usedMarket')
          .where('goodsName', isGreaterThanOrEqualTo: keyword)
          .where('goodsName', isLessThan: keyword + 'z')
          .get();
    return result;
  }
  
  
  //물품 등록
  Future<void> addGoods(String category, String goodsName, String price, String tradePlace, List images, List imageDescription)  async {
      //사진 저장
      List<String> imageUrlList = []; //등록된 이미지들의 url을 저장할 변수
      //등록할 사진이 1장 이상 있으면, 사진 개수만큼 한장씩 반복해서 올림
      if (images.isNotEmpty) {
        for (int i = 0; i < images.length; i++) {
          Uint8List bytes = await images[i].readAsBytes(); //받아온 이미지가 XFile 타입이므로 DB에 업로드하기 위해 타입을 변환함. Uint8List 타입으로 하는 이유는 웹,앱에서 모두 가능하기 때문
          final projectImages =
          FirebaseStorage.instance.ref().child('usedMarket').child(uid).child('${Timestamp.now().millisecondsSinceEpoch}.jpg');
          UploadTask uploadTask = projectImages.putData(bytes, SettableMetadata(contentType: 'image/jpg'));
          TaskSnapshot taskSnapshot = await uploadTask;
          final imageUrl = await taskSnapshot.ref.getDownloadURL(); //저장한 사진을 나중에 읽어오기 위해 이미지 URL을 DB에 저장해야됨
          imageUrlList.add(imageUrl); //사진이 여러장일 수 있으므로, 각 사진의 URL을 리스트 변수 imageUrlList에 저장함
        }
      }
      //데이터 저장
      await FirebaseFirestore.instance.collection('usedMarket').doc().set({
        'category': category,
        'goodsName': goodsName,
        'price': price,
        'tradePlace': tradePlace,
        'imageDescription': imageDescription,
        'imageUrlList': imageUrlList,
        'registeredDate': DateTime.now(),
        'writer': uid,
      });


  }




}