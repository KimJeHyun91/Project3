import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('결제 관리')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '결제 방식을 선택해주세요.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),

            // ✅ 카드 결제 - 충전 금액 입력 받기
            ElevatedButton.icon(
              onPressed: () => _showAmountDialog(context),
              icon: const Icon(Icons.account_balance_wallet),
              label: const Text('선불 충전 결제 (카드 결제)'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF00A8A8),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),

            // 계좌이체 버튼
            ElevatedButton.icon(
              onPressed: () =>
                  Navigator.pushNamed(context, '/payment-transfer'),
              icon: const Icon(Icons.account_balance),
              label: const Text('가상 계좌 이체'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF205295),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAmountDialog(BuildContext context) {
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('충전 금액 입력'),
            content: TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '충전 금액 (원)',
                hintText: '예: 1000',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), // 취소 버튼은 그대로 pop 유지
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () {
                  final String amountText = amountController.text;
                  final int? amount = int.tryParse(amountText);
                  if (amount != null && amount > 0) {
                    Navigator.pushNamed(
                      context,
                      '/payment-test',
                      arguments: amount,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('유효한 금액을 입력해주세요.')),
                    );
                  }
                },
                child: const Text('확인'),
              ),
            ],
          ),
    );
  }
}