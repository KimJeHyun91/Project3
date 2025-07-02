import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DriverRequestDetailPage extends StatelessWidget {
  final DocumentSnapshot requestDoc;

  const DriverRequestDetailPage({super.key, required this.requestDoc});

  @override
  Widget build(BuildContext context) {
    final data = requestDoc.data() as Map<String, dynamic>;

    String formatDate(Timestamp ts) {
      return DateFormat('yyyy-MM-dd HH:mm').format(ts.toDate());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('요청 주문 상세')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _infoTile('출발지', data['pickupAddress']),
            _infoTile('도착지', data['deliveryAddress']),
            _infoTile('차종', data['vehicleType']),
            _infoTile('중량', '${data['weight']}kg'),
            _infoTile('예상금액', '${data['price']}원'),
            _infoTile('픽업시간', formatDate(data['pickupTime'])),
            _infoTile('보관/냉장', data['isRefrigerated'] ? 'O' : 'X'),
            _infoTile('파손주의', data['isFragile'] ? 'O' : 'X'),
            _infoTile('화물 종류', data['itemType']),
            _infoTile('크기', '${data['length']} × ${data['width']} × ${data['height']}'),
            _infoTile('화주명', data['senderName']),
            _infoTile('연락처', data['senderPhone']),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: 입찰 기능 연결 예정
              },
              child: const Text('입찰 제안하기'),
            )
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String title, String? value) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value ?? '-'),
    );
  }
}