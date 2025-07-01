import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrackingScreen extends StatelessWidget {
  final String requestId;

  const TrackingScreen({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    final docRef = FirebaseFirestore.instance.collection('delivery_requests').doc(requestId);

    return Scaffold(
      appBar: AppBar(title: const Text('배송 상태 추적')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: docRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('요청 정보를 불러올 수 없습니다.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final status = data['status'] ?? '알 수 없음';

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('현재 상태: $status', style: const TextStyle(fontSize: 22)),
                const SizedBox(height: 32),
                if (status != '하차 완료')
                  ElevatedButton.icon(
                    icon: const Icon(Icons.update),
                    label: const Text('다음 상태로 업데이트'),
                    onPressed: () async {
                      final nextStatus = _getNextStatus(status);
                      await docRef.update({'status': nextStatus});
                    },
                  )
                else
                  const Text(
                    '배송이 완료되었습니다.',
                    style: TextStyle(fontSize: 18, color: Colors.green),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 다음 상태 반환 로직
  String _getNextStatus(String current) {
    switch (current) {
      case '요청됨':
        return '상차 중';
      case '상차 중':
        return '운송 중';
      case '운송 중':
        return '하차 완료';
      default:
        return '하차 완료';
    }
  }
}
