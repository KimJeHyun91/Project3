import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'tracking_screen.dart';

class TrackingListScreen extends StatelessWidget {
  const TrackingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('로그인이 필요합니다.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('배송 추적 목록')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('delivery_requests')
            .where('uid', isEqualTo: user.uid)
            .where('status', whereIn: ['배송중', '배송 완료', '대금 지불 완료']) // 추적 대상 상태
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(child: Text('진행 중인 배송이 없습니다.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final pickup = data['pickupAddress'] ?? '-';
              final delivery = data['deliveryAddress'] ?? '-';

              return ListTile(
                title: Text('$pickup → $delivery'),
                subtitle: Text('상태: ${data['status']}'),
                trailing: const Icon(Icons.arrow_forward_ios),
                // onTap: () {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (_) => TrackingScreen(requestId: doc.id),
                //     ),
                //   );
                // },
                onTap: () async {
                  final doc = docs[index];
                  final data = doc.data() as Map<String, dynamic>;
                  final status = data['status'] ?? '';

                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('배송 상태'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (status == '배송중')
                            const Text('현재 배송중입니다.')
                          else if (status == '배송 완료') ...[
                            const Text(
                              '배송이 완료되었습니다.\n물품 수령 여부를 확인하신 후\n"배송 완료 확인" 버튼을 눌러주세요.',
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('delivery_requests')
                                    .doc(doc.id)
                                    .update({
                                  'status': '대금 지불 완료',
                                  'updatedAt': FieldValue.serverTimestamp(),
                                });

                                if (context.mounted) {
                                  Navigator.pop(context); // 닫기
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('배송 완료가 확인되었습니다.')),
                                  );
                                }
                              },
                              child: const Text('배송 완료 확인'),
                            ),
                          ]
                          else
                            Text('상태: $status'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('닫기'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}