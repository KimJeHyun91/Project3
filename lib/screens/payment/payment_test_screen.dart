import 'package:flutter/material.dart';
import 'package:portone_flutter/iamport_payment.dart';
import 'package:portone_flutter/model/payment_data.dart';

class PaymentTestScreen extends StatelessWidget {
  final int amount;
  const PaymentTestScreen({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return IamportPayment(
      appBar: AppBar(
        title: const Text('테스트 결제'),
      ),

      // 웹뷰 로딩 중 보여줄 화면
      initialChild: const Center(
        child: Text(
          '잠시만 기다려주세요...',
          style: TextStyle(fontSize: 20),
        ),
      ),

      // [필수] PortOne 가맹점 식별코드
      userCode: 'imp19424728',

      // [필수] 결제 데이터
      data: PaymentData(
        pg: 'html5_inicis', // 테스트 PG사
        payMethod: 'card', // 결제수단
        name: '운송 결제 테스트',
        merchantUid: 'mid_${DateTime.now().millisecondsSinceEpoch}', // 고유 주문번호
        amount: amount, // 테스트 결제 금액
        buyerName: '홍길동',
        buyerTel: '01012345678',
        buyerEmail: 'test@test.com',
        buyerAddr: '서울시 강남구 테헤란로',
        buyerPostcode: '06236',
        appScheme: 'logisticsapp', // 앱 복귀용 스킴 (AndroidManifest에 등록 필요)
        cardQuota: [2, 3], // UI 내 할부 옵션 제한
      ),

      // [필수] 결제 완료 후 콜백
      callback: (Map<String, String> result) {
        if (result['imp_success'] == 'true') {
          print('✅ 결제 성공: ${result['imp_uid']}');
        } else {
          print('❌ 결제 실패: ${result['error_msg']}');
        }

        Navigator.pop(context); // 결제 후 뒤로가기
      },
    );
  }
}
