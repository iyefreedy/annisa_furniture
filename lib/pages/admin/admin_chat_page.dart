import 'package:annisa_furniture/models/room.dart';
import 'package:annisa_furniture/services/cloud/firebase_cloud_storage.dart';
import 'package:flutter/material.dart';

class AdminChatPage extends StatefulWidget {
  const AdminChatPage({Key? key}) : super(key: key);

  @override
  State<AdminChatPage> createState() => _AdminChatPageState();
}

class _AdminChatPageState extends State<AdminChatPage> {
  late FirebaseCloudStorage _firebaseCloudStorage;

  @override
  void initState() {
    _firebaseCloudStorage = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesan'),
      ),
      body: StreamBuilder<List<Room>>(
        stream: _firebaseCloudStorage.getRooms(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final rooms = snapshot.data!;
            print(rooms.length);
            return ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(rooms[index].id),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
