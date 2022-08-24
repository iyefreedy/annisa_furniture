import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  final String id;
  final String userId;
  final String phoneNumber;
  final String productId;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  Room({
    required this.id,
    required this.userId,
    required this.phoneNumber,
    required this.productId,
    required this.createdAt,
    required this.updatedAt,
  });

  Room.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        userId = snapshot.data()['user_id'],
        phoneNumber = snapshot.data()['phone_number'],
        productId = snapshot.data()['product_id'],
        createdAt = snapshot.data()['created_at'],
        updatedAt = snapshot.data()['updated_at'];
}
