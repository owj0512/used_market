import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MemberInfoController {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  //회원 정보 가져오기
  getUserInfo() async {
    var result = await FirebaseFirestore.instance.collection('memberInfo').doc(uid).get();
    return result.data();
  }

  getUserName() async{
    var result = await FirebaseFirestore.instance.collection('memberInfo').doc(uid).get();
    var data = result.data() as Map;
    return data['name'];
  }

  getUserNameFromUid(String uid) async{
    var result = await FirebaseFirestore.instance.collection('memberInfo').doc(uid).get();
    var data = result.data() as Map;
    return data['name'];
  }

  //프로필 사진 저장
  Future<void> uploadProfilePhoto(var profilePhoto) async{
    Uint8List bytes = await profilePhoto.readAsBytes();
    final image = FirebaseStorage.instance.ref().child('memberInfo').child('profilePhoto').child(uid).child('${DateTime.now()}.jpg');
    UploadTask uploadTask = image.putData(bytes, SettableMetadata(contentType: 'image/jpg'));
    TaskSnapshot taskSnapshot = await uploadTask;
    final profilePhotoUrl = await taskSnapshot.ref.getDownloadURL();
    FirebaseFirestore.instance.collection('memberInfo').doc(uid).update({'profilePhotoUrl': profilePhotoUrl});
  }

  //프로필 사진 삭제
  deleteProfilePhoto(String profilePhotoUrl) async{
    FirebaseFirestore.instance.collection('memberInfo').doc(uid).update({'profilePhotoUrl': FieldValue.delete()});
    Reference ref = FirebaseStorage.instance.refFromURL(profilePhotoUrl);
    await ref.delete();
  }





}
