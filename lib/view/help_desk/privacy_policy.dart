import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

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
            title: const Text('개인정보 처리방침', style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold))),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('중고마켓 개인정보 처리방침', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text(
                    '중고마켓(이하 “회사”라 함)은 정보주체의 자유와 권리 보호를 위해 「개인정보 보호법」 및 관계 법령이 정한 바를 준수하여, 적법하게 개인정보를 처리하고 안전하게 관리하고 있습니다. 이에 「개인정보 보호법」 제30조에 따라 정보주체에게 개인정보 처리에 관한 절차 및 기준을 안내하고, 이와 관련한 고충을 신속하고 원활하게 처리할 수 있도록 하기 위하여 다음과 같이 개인정보 처리방침을 수립·공개합니다.'),
                const SizedBox(height: 8),
                Container(
                  width: 1000,
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: [
                        Text('목차\n'
                            '▪ 개인정보의 처리 목적\n'
                            '▪ 개인정보의 처리 및 보유기간\n'
                            '▪ 처리하는 개인정보 항목\n'
                            '▪ 개인정보의 파기\n'
                            '▪ 정보주체와 법정대리인의 권리·의무 및 행사방법\n'
                            '▪ 개인정보의 안전성 확보조치\n'
                            '▪ 개인정보 자동 수집 장치의 설치·운영 및 거부에 관한 사항\n'
                            '▪ 개인정보보호책임자 및 연락처\n'
                            '▪ 개인정보 처리방침의 변경'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('▪ 개인정보의 처리 목적', style: TextStyle(fontWeight: FontWeight.bold)),
                const Text(
                    '회사는 다음의 목적을 위하여 개인정보를 처리합니다. 처리하고 있는 개인정보는 다음의 목적 이외의 용도로는 이용되지 않으며, 이용 목적이 변경되는 경우에는 「개인정보 보호법」 제18조에 따라 별도의 동의를 받는 등 필요한 조치를 이행할 예정입니다.\n'
                    ' 1. 회원 가입 및 관리 회원 가입의사 확인, 회원제 서비스 제공에 따른 본인 식별·인증, 회원자격 유지·관리, 서비스 부정이용 방지, 만 14세 미만 아동의 개인정보 처리 시 법정대리인의 동의 여부 확인, 각종 고지·통지, 고충처리 목적으로 개인정보를 처리합니다.\n'
                    ' 2. 재화 또는 서비스 제공 물품배송, 서비스 제공, 계약서·청구서 발송, 콘텐츠 제공, 맞춤서비스 제공, 본인인증, 연령인증, 요금결제·정산, 채권추심으로 개인정보를 처리합니다.\n'),
                const Text('▪ 개인정보의 처리 및 보유기간', style: TextStyle(fontWeight: FontWeight.bold)),
                const Text('① 회사는 법령에 따른 개인정보 보유·이용기간 또는 정보주체로부터 개인정보를 수집 시에 동의 받은 개인정보 보유·이용기간 내에서 개인정보를 처리· 보유합니다.\n'
                    '② 각각의 개인정보 처리 및 보유 기간은 다음과 같습니다.\n'
                    ' 1. 회원 가입 및 관리 : 사업자/단체 홈페이지/앱 탈퇴 시까지. 다만, 다음의 사유에 해당하는 경우에는 해당 사유 종료 시까지\n'
                    '  1) 관계 법령 위반에 따른 수사·조사 등이 진행 중인 경우에는 해당 수사·조사 종료 시까지\n'
                    '  2) 홈페이지 이용에 따른 채권·채무관계 잔존 시에는 해당 채권·채무관계 정산 시까지\n'
                    '  3) <예외 사유> 시에는 <보유기간>까지\n'
                    ' 2. 재화 또는 서비스 제공 : 재화·서비스 공급완료 및 요금결제·정산 완료 시까지. 다만, 다음의 사유에 해당하는 경우에는 해당 기간 종료 시까지\n'
                    '  1) 「전자상거래 등에서의 소비자 보호에 관한 법률」에 따른 표시·광고, 계약내용 및 이행 등 거래에 관한 기록\n'
                    '   - 표시·광고에 관한 기록 : 6개월\n'
                    '   - 계약 또는 청약철회, 대금결제, 재화 등의 공급기록 : 5년\n'
                    '   - 소비자 불만 또는 분쟁처리에 관한 기록 : 3년\n'
                    '  2) 「통신비밀보호법」에 따른 통신사실확인자료 보관\n'
                    '   - 가입자 전기통신일시, 개시·종료시간, 상대방 가입자번호, 사용도수, 발신기지국 위치추적자료 : 1년\n'
                    '   - 컴퓨터통신, 인터넷 로그기록자료, 접속지 추적자료 : 3개월\n'),
                const Text('▪ 처리하는 개인정보 항목', style: TextStyle(fontWeight: FontWeight.bold)),
                const Text('회사는 다음의 개인정보 항목을 처리하고 있습니다.\n'
                    ' 1. 회원가입, 회원관리, 서비스 제공\n'
                    '  - 필수항목 : 성명, 휴대폰 번호, 이메일 주소\n'),
                const Text('▪ 개인정보의 파기', style: TextStyle(fontWeight: FontWeight.bold)),
                const Text('① 회사는 개인정보 보유기간의 경과, 처리목적 달성 등 개인정보가 불필요하게 되었을 때에는 지체없이 해당 개인정보를 파기합니다.\n'
                    '② 정보주체로부터 동의 받은 개인정보 보유기간이 경과하거나 처리목적이 달성되었음에도 불구하고 다른 법령에 따라 개인정보를 계속 보존하여야 하는 경우에는, 해당 개인정보를 별도의 데이터베이스(DB)로 옮기거나 보관장소를 달리하여 보존합니다.\n'
                    '③ 개인정보 파기의 절차 및 방법은 다음과 같습니다.\n'
                    ' 1. 파기절차 : 회사는 파기 사유가 발생한 개인정보를 선정하고, 회사의 개인정보 보호책임자의 승인을 받아 개인정보를 파기합니다.\n'
                    ' 2. 파기방법 : 회사는 전자적 파일 형태로 기록·저장된 개인정보는 기록을 재생할 수 없도록 파기하며, 종이 문서에 기록·저장된 개인정보는 분쇄기로 분쇄 하거나 소각하여 파기합니다.\n'),
                const Text('▪ 정보주체와 법정대리인의 권리·의무 및 행사방법', style: TextStyle(fontWeight: FontWeight.bold)),
                const Text(
                    '정보주체는 언제든지 등록되어 있는 자신의 개인정보를 조회하거나 수정할 수 있으며 정보삭제 및 처리정지를 요청할 수도 있습니다. 정보삭제 또는 처리정지를 원하시는 경우 개인정보보호 책임자에게 이메일로 연락하시면 지체 없이 조치하겠습니다.\n'),
                const Text('▪ 개인정보의 안전성 확보조치', style: TextStyle(fontWeight: FontWeight.bold)),
                const Text('회사는 개인정보의 안전성 확보를 위해 다음과 같은 조치를 취하고 있습니다.\n'
                    ' 1. 관리적 조치 : 내부관리계획 수립·시행, 전담조직 운영, 정기적 직원 교육\n'
                    ' 2. 기술적 조치 : 개인정보처리시스템 등의 접근권한 관리, 접근통제시스템 설치, 개인정보의 암호화, 보안프로그램 설치 및 갱신\n'
                    ' 3. 물리적 조치 : 사무실, 자료보관실 등의 접근통제\n'),
                const Text('▪ 개인정보 자동 수집 장치의 설치·운영 및 거부에 관한 사항', style: TextStyle(fontWeight: FontWeight.bold)),
                const Text(
                    '회사는 웹/앱 서비스를 제공하기 위해 ‘쿠키(cookie)’를 사용합니다. 쿠키는 웹사이트/앱을 운영하는데 이용되고 서버가 이용자의 컴퓨터 브라우저/모바일 기기에서 보내는 소량의 정보이며 이용자들의 PC 내의 하드디스크 및 모바일 기기 메모리에 저장될 수 있습니다.\n'
                    '  - 쿠키의 사용목적 : 로그인 상태 유지를 위해 사용합니다(이용 동의 시)\n'
                    '  - 쿠키의 설치·운영 및 거부\n'
                    '   · 웹 : 브라우저 상단의 도구>인터넷 옵션>개인정보 메뉴의 옵션 설정\n'
                    '   · 앱 : 설정 > 애플리케이션 > 권한 삭제\n'
                    '* 쿠키 저장을 거부할 경우 별도의 관련 서비스 이용에 어려움이 발생할 수 있습니다.\n'),
                const Text('▪ 개인정보보호책임자 및 연락처', style: TextStyle(fontWeight: FontWeight.bold)),
                const Text('① 회사는 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보보호책임자를 지정하고 있습니다.\n'
                    '② 정보주체는 「개인정보 보호법」 제35조에 따른 개인정보의 열람 청구를 아래의 부서에 할 수 있습니다. 회사는 정보주체의 개인정보 열람청구가 신속하게 처리되도록 노력하겠습니다.'),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                  child: const Column(
                    children: [
                      Text('성명 : 오원준\n'
                          '이메일 : owj0001@gmail.com'),
                    ],
                  ),
                ),
                const Text(
                    '③ 정보주체는 회사의 서비스(또는 사업)을 이용하시면서 발생한 모든 개인정보보호 관련 문의, 불만처리, 피해구제 등에 관한 사항을 개인정보 보호책임자 및 담당부서로 문의할 수 있습니다. 회사는 정보주체의 문의에 대해 지체없이 답변 및 처리해드릴 것입니다.\n'),
                const Text('▪ 개인정보 처리방침의 변경', style: TextStyle(fontWeight: FontWeight.bold)),
                const Text('① 이 개인정보 처리방침은 2023. 8. 1.부터 적용됩니다.'),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
