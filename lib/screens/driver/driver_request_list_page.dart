import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DriverRequestListPage extends StatelessWidget {
  const DriverRequestListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('요청 주문 목록')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('delivery_requests')
            .where('status', isNotEqualTo: '매칭됨') // ✅ 매칭 안 된 주문만
            .orderBy('status') // ✅ isNotEqualTo 쓰려면 필수
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('미매칭 주문이 없습니다.'));
          }

          final requests = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: requests.length,
            separatorBuilder: (_, __) => const Divider(height: 16),
            itemBuilder: (context, index) {
              final doc = requests[index];
              final data = doc.data() as Map<String, dynamic>;

              return ListTile(
                leading: const Icon(Icons.local_shipping),
                title: Text('${data['pickupAddress']} → ${data['deliveryAddress']}'),
                subtitle: Text('차량: ${data['vehicleType']} / 중량: ${data['weight']}kg'),
                trailing: Text('${data['price']}원'),
                  onTap: () {
                    print('📦 전달할 doc: ${doc.id}');
                    Navigator.pushNamed(
                      context,
                      '/driver/request-detail',
                      arguments: doc,
                    );
                  }
              );
            },
          );
        },
      ),
    );
  }
}