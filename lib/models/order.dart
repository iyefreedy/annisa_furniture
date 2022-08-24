import 'package:annisa_furniture/models/product.dart';

import 'package:annisa_furniture/services/cloud/cloud_storage_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class Order {
  final String id;
  final String userId;
  final String productId;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  const Order({
    required this.id,
    required this.userId,
    required this.productId,
    required this.createdAt,
    required this.updatedAt,
  });

  Order.fromDocument(
      Product product, DocumentSnapshot<Map<String, Object?>> document)
      : this(
          id: document.id,
          userId: document.data()!['user_id'] as String,
          productId: document.data()!['product_id'] as String,
          createdAt: document.data()!['created_at'] as Timestamp,
          updatedAt: document.data()!['updated_at'] as Timestamp,
        );

  Order.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
  ) : this(
          id: snapshot.id,
          userId: snapshot.data()[userIdField],
          productId: snapshot.data()[productIdField],
          createdAt: snapshot.data()[createdAtField],
          updatedAt: snapshot.data()[updatedAtField],
        );

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': null,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
