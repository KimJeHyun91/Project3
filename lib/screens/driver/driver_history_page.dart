import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DriverHistoryPage extends StatelessWidget {
  const DriverHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('로그인이 필요합니다.')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('배송 이력')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('delivery_requests')
            .where('assignedDriverId', isEqualTo: user.uid)
            .where('status', whereIn: ['배송 완료', '대금 지불 완료'])
            .orderBy('pickupTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text('배송 이력이 없습니다.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final pickup = data['pickupAddress'] ?? '-';
              final delivery = data['deliveryAddress'] ?? '-';
              final status = data['status'] ?? '-';
              final price = data['price']?.toString() ?? '-';
              final time = (data['pickupTime'] as Timestamp).toDate();

              return Card(
                margin: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  title: Text('$pickup → $delivery'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('운송일: ${DateFormat('yyyy-MM-dd').format(time)}'),
                      Text('상태: $status'),
                      Text('운임: $price 원'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}