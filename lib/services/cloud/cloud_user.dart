import 'package:cloud_firestore/cloud_firestore.dart';

class CloudUser {
  final String id;
  final String role;

  CloudUser({
    required this.id,
    required this.role,
  });

  CloudUser.fromSnashot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        role = snapshot.data()['role'];
}
