import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RequestDetailScreen extends StatelessWidget {
  final String requestId;

  const RequestDetailScreen({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('요청 상세 보기')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('delivery_requests')
            .doc(requestId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('요청 정보를 불러올 수 없습니다.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                _infoTile('보내는 사람', data['senderName'] ?? ''),
                _infoTile('연락처', data['senderPhone'] ?? ''),
                _infoTile('출발지', data['pickupAddress'] ?? ''),
                _infoTile('도착지', data['deliveryAddress'] ?? ''),
                _infoTile('픽업 시간', data['pickupTime']?.toDate().toString() ?? ''),
                _infoTile('품목', data['itemType'] ?? ''),
                _infoTile('차량 종류', data['vehicleType'] ?? ''),
                _infoTile('희망 운임', '${data['price'] ?? '미입력'}원'),
                _infoTile('무게', data['weight'] ?? ''),
                _infoTile('크기', '${data['width']} x ${data['length']} x ${data['height']}'),
                _infoTile('냉장/냉동 필요', data['isRefrigerated'] == true ? '예' : '아니오'),
                _infoTile('리프트 필요', data['needsLift'] == true ? '예' : '아니오'),
                _infoTile('파손 주의', data['isFragile'] == true ? '예' : '아니오'),
                _infoTile('물품 설명', data['itemDescription'] ?? ''),
                _infoTile('요청 상태', data['status'] ?? ''),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _cancelRequest(context),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('배차 취소'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _showQuotesDialog(context),
                        child: const Text('견적 확인'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _cancelRequest(BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('delivery_requests')
        .doc(requestId)
        .update({'status': '취소됨'});

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('배송 요청이 취소되었습니다.')),
      );
      Navigator.pop(context);
    }
  }

  void _showQuotesDialog(BuildContext context) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('delivery_requests')
        .doc(requestId)
        .collection('quotes')
        .get();

    final quotes = snapshot.docs;

    if (quotes.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('견적 없음'),
          content: Text('아직 도착한 견적이 없습니다.'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('도착한 견적'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: quotes.map((doc) {
              final data = doc.data();
              return ListTile(
                title: Text('차주명: ${data['driverName'] ?? '알 수 없음'}'),
                subtitle: Text('견적금액: ${data['price']}원'),
                trailing: ElevatedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('delivery_requests')
                        .doc(requestId)
                        .update({
                      'status': '배차 확정',
                      'assignedDriverId': data['driverId'],
                      'assignedPrice': data['price'],
                    });
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('배차가 확정되었습니다.')),
                      );
                    }
                  },
                  child: const Text('배차 확정'),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
