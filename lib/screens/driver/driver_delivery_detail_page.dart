import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DriverDeliveryDetailPage extends StatelessWidget {
  final DocumentSnapshot deliveryDoc;

  const DriverDeliveryDetailPage({super.key, required this.deliveryDoc});

  @override
  Widget build(BuildContext context) {
    final data = deliveryDoc.data() as Map<String, dynamic>;
    final pickup = data['pickupAddress'] ?? '-';
    final delivery = data['deliveryAddress'] ?? '-';
    final status = data['status'] ?? '';
    final pickupTime = (data['pickupTime'] as Timestamp).toDate();

    return Scaffold(
      appBar: AppBar(title: const Text('배송 상세')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('출발지: $pickup'),
            Text('도착지: $delivery'),
            Text('픽업 시간: ${DateFormat('yyyy-MM-dd HH:mm').format(pickupTime)}'),
            Text('상태: $status', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            if (status == '배차 확정')
              _buildActionButton(context, '배송 시작', '배송중'),
            if (status == '배송중')
              _buildActionButton(context, '배송 완료', '배송 완료'),
            if (status == '배송 완료')
              const Text('배송이 완료된 요청입니다.', style: TextStyle(color: Colors.green)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String label, String nextStatus) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          await FirebaseFirestore.instance
              .collection('delivery_requests')
              .doc(deliveryDoc.id)
              .update({'status': nextStatus});

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('상태가 "$nextStatus"로 변경되었습니다')),
            );
            Navigator.pop(context); // 뒤로가기
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: nextStatus == '배송 완료' ? Colors.green : Colors.orange,
        ),
        child: Text(label),
      ),
    );
  }
}