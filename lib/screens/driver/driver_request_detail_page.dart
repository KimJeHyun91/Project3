import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DriverRequestDetailPage extends StatefulWidget {
  final DocumentSnapshot requestDoc;

  const DriverRequestDetailPage({super.key, required this.requestDoc});

  @override
  State<DriverRequestDetailPage> createState() =>
      _DriverRequestDetailPageState();
}

class _DriverRequestDetailPageState extends State<DriverRequestDetailPage> {
  bool _alreadyBid = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkAlreadyBid();
  }

  Future<void> _checkAlreadyBid() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final hasBid = await _hasAlreadyBid(widget.requestDoc.id, user.uid);
    if (mounted) {
      setState(() {
        _alreadyBid = hasBid;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.requestDoc.data() as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(title: const Text('요청 주문 상세')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _infoRow('출발지', data['pickupAddress'], '도착지', data['deliveryAddress']),
            _infoRow('차종', data['vehicleType'], '중량', '${data['weight']}kg'),
            _infoRow('예상금액', '${data['price']}원', '픽업시간', formatDate(data['pickupTime'])),
            _infoRow('보관/냉장', data['isRefrigerated'] ? 'O' : 'X', '파손주의', data['isFragile'] ? 'O' : 'X'),
            _infoRow('화물 종류', data['itemType'], '화물 크기', '${data['length']} × ${data['width']} × ${data['height']}'),
            _infoRow('화주명', data['senderName'], '연락처', data['senderPhone']),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _alreadyBid ? null : () => _showBidDialog(context),
                child: Text(_alreadyBid ? '이미 제안 완료' : '입찰 제안하기'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label1, String value1, String label2, String value2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(child: _infoTile(label1, value1)),
          const SizedBox(width: 12),
          Expanded(child: _infoTile(label2, value2)),
        ],
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  String formatDate(Timestamp timestamp) {
    final dt = timestamp.toDate();
    return DateFormat('yyyy-MM-dd HH:mm').format(dt);
  }

  Future<bool> _hasAlreadyBid(String requestId, String driverId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('delivery_requests')
        .doc(requestId)
        .collection('quotes')
        .where('driverId', isEqualTo: driverId)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  void _showBidDialog(BuildContext context) {
    final _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('입찰 금액 제안'),
        content: TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: '제안 금액 (원)',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              final priceText = _controller.text;
              final price = int.tryParse(priceText);
              if (price == null) return;

              final user = FirebaseAuth.instance.currentUser;
              final driverDoc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
              final driverData = driverDoc.data()!;

              await FirebaseFirestore.instance
                  .collection('delivery_requests')
                  .doc(widget.requestDoc.id)
                  .collection('quotes')
                  .add({
                'driverId': user.uid,
                'driverName': driverData['displayName'] ?? '익명',
                'driverPhone': driverData['email'] ?? '',
                'price': price,
                'createdAt': Timestamp.now(),
              });

              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('입찰 제안이 완료되었습니다!')),
                );
                setState(() {
                  _alreadyBid = true;
                });
              }
            },
            child: const Text('제안하기'),
          ),
        ],
      ),
    );
  }
}