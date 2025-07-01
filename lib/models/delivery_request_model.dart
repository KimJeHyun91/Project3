import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryRequest {
  final String id;
  final String senderName;
  final String senderPhone;
  final String pickupAddress;
  final String deliveryAddress;
  final DateTime pickupTime;
  final String itemDescription;
  final String itemType;
  final String weight;
  final String width;
  final String height;
  final String length;
  final bool isRefrigerated;
  final bool needsLift;
  final bool isFragile;
  final String vehicleType;
  final String status;

  DeliveryRequest({
    required this.id,
    required this.senderName,
    required this.senderPhone,
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.pickupTime,
    required this.itemDescription,
    required this.itemType,
    required this.weight,
    required this.width,
    required this.height,
    required this.length,
    required this.isRefrigerated,
    required this.needsLift,
    required this.isFragile,
    required this.vehicleType,
    required this.status,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'senderName': senderName,
    'senderPhone': senderPhone,
    'pickupAddress': pickupAddress,
    'deliveryAddress': deliveryAddress,
    'pickupTime': Timestamp.fromDate(pickupTime),
    'itemDescription': itemDescription,
    'itemType': itemType,
    'weight': weight,
    'width': width,
    'height': height,
    'length': length,
    'isRefrigerated': isRefrigerated,
    'needsLift': needsLift,
    'isFragile': isFragile,
    'vehicleType': vehicleType,
    'status': status,
  };

  factory DeliveryRequest.fromMap(Map<String, dynamic> map) {
    return DeliveryRequest(
      id: map['id'] ?? '',
      senderName: map['senderName'] ?? '',
      senderPhone: map['senderPhone'] ?? '',
      pickupAddress: map['pickupAddress'] ?? '',
      deliveryAddress: map['deliveryAddress'] ?? '',
      pickupTime: (map['pickupTime'] as Timestamp).toDate(),
      itemDescription: map['itemDescription'] ?? '',
      itemType: map['itemType'] ?? '',
      weight: map['weight'] ?? '',
      width: map['width'] ?? '',
      height: map['height'] ?? '',
      length: map['length'] ?? '',
      isRefrigerated: map['isRefrigerated'] ?? false,
      needsLift: map['needsLift'] ?? false,
      isFragile: map['isFragile'] ?? false,
      vehicleType: map['vehicleType'] ?? '',
      status: map['status'] ?? '요청됨',
    );
  }
}
