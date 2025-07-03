// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class TrackingScreen extends StatelessWidget {
//   final String requestId;
//
//   const TrackingScreen({super.key, required this.requestId});
//
//   @override
//   Widget build(BuildContext context) {
//     final docRef = FirebaseFirestore.instance.collection('delivery_requests').doc(requestId);
//
//     return Scaffold(
//       appBar: AppBar(title: const Text('배송 상태 추적')),
//       body: StreamBuilder<DocumentSnapshot>(
//         stream: docRef.snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (!snapshot.hasData || !snapshot.data!.exists) {
//             return const Center(child: Text('요청 정보를 불러올 수 없습니다.'));
//           }
//
//           final data = snapshot.data!.data() as Map<String, dynamic>;
//           final status = data['status'] ?? '알 수 없음';
//
//           return Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text('현재 상태: $status', style: const TextStyle(fontSize: 22)),
//                 const SizedBox(height: 32),
//
//                 if (status == '배송 완료') ...[
//                   const Text(
//                     '배송 완료 확인 버튼을 누르시면 대금이 차주에게 지급됩니다.\n물품이 배송지에 도착했는지 확인 후 눌러주세요.',
//                     style: TextStyle(fontSize: 16),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 24),
//                   ElevatedButton(
//                     onPressed: () async {
//                       await docRef.update({'status': '대금 결제 완료'});
//
//                       if (context.mounted) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text('배송 완료가 확인되었습니다.')),
//                         );
//                         Navigator.pop(context);
//                       }
//                     },
//                     child: const Text('배송 완료 확인'),
//                   ),
//                 ],
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }