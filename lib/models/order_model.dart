// lib/models/order_model.dart

class Order {
  final String id;
  final String senderId;
  final String pickupAddress;
  final String deliveryAddress;
  final String itemCategory; // 품목 (이사짐, 공산품 등)
  final double weight;
  final String size; // 가로x세로x높이 형태
  final List<String> specialConditions;
  final String vehicleType;
  final DateTime desiredPickupTime;
  final double suggestedPrice;
  final String status;

  Order({
    required this.id,
    required this.senderId,
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.itemCategory,
    required this.weight,
    required this.size,
    required this.specialConditions,
    required this.vehicleType,
    required this.desiredPickupTime,
    required this.suggestedPrice,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'pickupAddress': pickupAddress,
      'deliveryAddress': deliveryAddress,
      'itemCategory': itemCategory,
      'weight': weight,
      'size': size,
      'specialConditions': specialConditions,
      'vehicleType': vehicleType,
      'desiredPickupTime': desiredPickupTime.toIso8601String(),
      'suggestedPrice': suggestedPrice,
      'status': status,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      senderId: map['senderId'],
      pickupAddress: map['pickupAddress'],
      deliveryAddress: map['deliveryAddress'],
      itemCategory: map['itemCategory'],
      weight: map['weight'],
      size: map['size'],
      specialConditions: List<String>.from(map['specialConditions']),
      vehicleType: map['vehicleType'],
      desiredPickupTime: DateTime.parse(map['desiredPickupTime']),
      suggestedPrice: map['suggestedPrice'],
      status: map['status'],
    );
  }
}
