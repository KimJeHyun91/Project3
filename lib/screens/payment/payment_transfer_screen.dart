import 'package:flutter/material.dart';

class PaymentTransferScreen extends StatelessWidget {
  const PaymentTransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const accountInfo = {
      '은행명': '국민은행',
      '계좌번호': '123-45-67890-00',
      '예금주': '플랫폼(주)',
    };

    return Scaffold(
      appBar: AppBar(title: const Text('계좌 이체 안내')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '아래 계좌로 운송료를 이체해주세요.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ...accountInfo.entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  SizedBox(width: 100, child: Text('${entry.key}:', style: const TextStyle(fontWeight: FontWeight.bold))),
                  Text(entry.value),
                ],
              ),
            )),
            const SizedBox(height: 24),
            const Text(
              '※ 이체 완료 후 차주가 확인하면 운송이 시작됩니다.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
