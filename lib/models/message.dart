import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String authorId;
  final String text;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  Message({
    required this.id,
    required this.authorId,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
  });

  Message.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        authorId = snapshot.data()['author_id'],
        text = snapshot.data()['text'],
        createdAt = snapshot.data()['created_at'],
        updatedAt = snapshot.data()['updated_at'];
}
