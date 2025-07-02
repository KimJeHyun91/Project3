import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_model.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('역할 선택')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '어떤 역할로 사용하시겠어요?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _selectRole(context, 'shipper'),
              icon: const Icon(Icons.local_shipping),
              label: const Text('화주 (배송 요청자)'),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _selectRole(context, 'driver'),
              icon: const Icon(Icons.directions_car),
              label: const Text('차주 (운송 기사)'),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            ),
          ],
        ),
      ),
    );
  }

  void _selectRole(BuildContext context, String role) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인이 필요합니다.')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'role': role,
        'updatedAt': Timestamp.now(),
      }, SetOptions(merge: true));

      if (role == 'shipper') {
        Navigator.pushReplacementNamed(
          context,
          '/home',
          arguments: AppUser(
            uid: user.uid,
            email: user.email ?? '',
            displayName: user.displayName ?? '',
          ),
        );
      } else if (role == 'driver') {
        Navigator.pushReplacementNamed(
          context,
          '/driver-home',
          arguments: AppUser(
            uid: user.uid,
            email: user.email ?? '',
            displayName: user.displayName ?? '',
          ),
        );      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('역할 저장 실패: $e')),
      );
    }
  }
}