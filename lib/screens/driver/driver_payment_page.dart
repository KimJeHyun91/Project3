import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DriverPaymentPage extends StatelessWidget {
  const DriverPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('로그인이 필요합니다.')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('정산 내역')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('delivery_requests')
            .where('assignedDriverId', isEqualTo: user.uid)
            .where('status', isEqualTo: '대금 지불 완료')
            .orderBy('updatedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text('정산 내역이 없습니다.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final price = data['price'] ?? 0;
              final updatedAt = (data['updatedAt'] as Timestamp?)?.toDate();

              return Card(
                margin: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  title: Text('+${price.toString()}원',
                      style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  subtitle: Text(updatedAt != null
                      ? '정산일: ${DateFormat('yyyy-MM-dd').format(updatedAt)}'
                      : '정산일: 없음'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}