import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/delivery_request_model.dart';
import 'request_detail_screen.dart';

class RequestListScreen extends StatelessWidget {
  const RequestListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('배송 요청 목록'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('delivery_requests')
            .orderBy('pickupTime', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('등록된 배송 요청이 없습니다.'));
          }

          final docs = snapshot.data!.docs;
          for (var doc in docs) {
            final data = doc.data() as Map<String, dynamic>;
            print('📦 ID: ${doc.id}');
            print('↳ pickupTime: ${data['pickupTime']} (${data['pickupTime'].runtimeType})');
            print('↳ pickupAddress: ${data['pickupAddress']}');
          }
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final request = DeliveryRequest.fromMap(data);
              final requestId = doc.id;

              return ListTile(
                leading: const Icon(Icons.local_shipping),
                title: Text('${request.pickupAddress} ➜ ${request.deliveryAddress}'),
                subtitle: Text('${request.itemType} | ${request.status}'),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/request-detail',
                    arguments: request,
                  );
                },
                trailing: IconButton(
                  icon: const Icon(Icons.track_changes),
                  tooltip: '상태 추적',
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/tracking',
                      arguments: requestId,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
