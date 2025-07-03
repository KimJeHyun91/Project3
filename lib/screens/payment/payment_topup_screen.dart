import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentTopUpScreen extends StatefulWidget {
  const PaymentTopUpScreen({super.key});

  @override
  State<PaymentTopUpScreen> createState() => _PaymentTopUpScreenState();
}

class _PaymentTopUpScreenState extends State<PaymentTopUpScreen> {
  final _amountController = TextEditingController();

  Future<void> _handleTopUp() async {
    final amount = int.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('유효한 금액을 입력해주세요.')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인이 필요합니다.')),
      );
      return;
    }

    try {
      // 🔹 Firestore에 잔액 누적 저장
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(
        {'balance': FieldValue.increment(amount)},
        SetOptions(merge: true),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('₩$amount 충전이 완료되었습니다.')),
      );

      // 🔸 충전 후 결제 테스트 페이지로 이동
      Navigator.pushReplacementNamed(context, '/payment-test');

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('충전에 실패했습니다. 다시 시도해주세요.')),
      );
    }
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('충전하기'),
            ),
          ],
        ),
      ),
    );
  }
}
