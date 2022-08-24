import 'package:annisa_furniture/constants/routes.dart';
import 'package:annisa_furniture/models/room.dart';
import 'package:annisa_furniture/services/cloud/firebase_cloud_storage.dart';
import 'package:flutter/material.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({Key? key}) : super(key: key);

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesan'),
      ),
      body: StreamBuilder<List<Room>>(
        stream: FirebaseCloudStorage().getRooms(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final rooms = snapshot.data!;
            return ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(rooms[index].id),
                  onTap: () => Navigator.of(context).pushNamed(
                    productChatRoute,
                    arguments: rooms[index].id,
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
