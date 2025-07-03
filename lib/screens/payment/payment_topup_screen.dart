import 'package:flutter/material.dart';

class PaymentTopUpScreen extends StatefulWidget {
  const PaymentTopUpScreen({super.key});

  @override
  State<PaymentTopUpScreen> createState() => _PaymentTopUpScreenState();
}

class _PaymentTopUpScreenState extends State<PaymentTopUpScreen> {
  final _amountController = TextEditingController();

  void _handleTopUp() {
    final amount = int.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('유효한 금액을 입력해주세요.')),
      );
      return;
    }

    // 실제 카드 결제 API 연동은 이곳에 구현 예정
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('₩$amount 충전이 완료되었습니다.')),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('카드 충전')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '충전할 금액을 입력하세요',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '금액 (₩)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _handleTopUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A8A8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('충전하기'),
            ),
          ],
        ),
      ),
    );
  }
}
