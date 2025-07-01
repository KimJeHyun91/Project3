import 'package:flutter/material.dart';
import '../../models/delivery_request_model.dart';

class RequestDetailScreen extends StatelessWidget {
  final DeliveryRequest request;

  const RequestDetailScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('요청 상세 보기')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _infoTile('보내는 사람', request.senderName),
            _infoTile('연락처', request.senderPhone),
            _infoTile('출발지', request.pickupAddress),
            _infoTile('도착지', request.deliveryAddress),
            _infoTile('픽업 시간', request.pickupTime.toString()),
            _infoTile('품목', request.itemType),
            _infoTile('무게', request.weight),
            _infoTile('크기', '${request.width} x ${request.length} x ${request.height}'),
            _infoTile('냉장/냉동 필요', request.isRefrigerated ? '예' : '아니오'),
            _infoTile('리프트 필요', request.needsLift ? '예' : '아니오'),
            _infoTile('파손 주의', request.isFragile ? '예' : '아니오'),
            _infoTile('물품 설명', request.itemDescription),
            _infoTile('요청 상태', request.status),
          ],
        ),
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
}
