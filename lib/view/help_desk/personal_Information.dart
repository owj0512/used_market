import 'package:flutter/material.dart';

class PersonalInformation extends StatelessWidget {
  const PersonalInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new),
                color: Colors.black,
              ),
              title: const Text('개인정보 수집·이용 동의',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold))),
          body: Container(
              margin: const EdgeInsets.all(10),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('개인정보 수집·이용 동의',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text('"중고마켓"은 “개인정보 보호법”에 따라 본인의 동의를 받아 개인정보를 수집·이용합니다.'),
                  Text('1. 개인정보 수집 목적: 회원 관리 및 서비스 제공'),
                  Text('2. 개인정보 수집 항목: 이름, 휴대폰 번호, 이메일 주소'),
                  Text('3. 보유기간: 회원 등록 기간'),
                  Text('4. 이용기간: 서비스 제공 기간'),
                  Text('※ 수집한 개인정보는 수집 및 이용 목적이 달성된 후에는 해당 정보를 지체 없이 파기합니다.'),
                  Text('* 개인정보 수집에 동의를 거부할 수 있으며, 동의를 거부할 경우 서비스를 이용하실 수 없습니다.'),
                ],
              ))),
    );
  }
}
