import 'package:annisa_furniture/models/message.dart';
import 'package:annisa_furniture/models/product.dart';
import 'package:annisa_furniture/models/room.dart';
import 'package:annisa_furniture/services/auth/auth_service.dart';
import 'package:annisa_furniture/services/cloud/firebase_cloud_storage.dart';
import 'package:annisa_furniture/utils/generics/get_arguments.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late TextEditingController _textController;

  String get userId => AuthService.firebase().currentUser!.id;
  Product? get widgetProduct => context.getArgument<Product>();
  String get roomId => context.getArgument<String>()!;

  Future<Room> createRoom() async {
    if (widgetProduct != null) {
      print(widgetProduct!.image![0]);
      return await FirebaseCloudStorage().createRoom(
        userId: userId,
        productId: widgetProduct!.id,
      );
    }

    return await FirebaseCloudStorage().getRoom(roomId: roomId);
  }

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widgetProduct != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Image.network(
                      widgetProduct!.image![0].toString(),
                      height: 50.0,
                    ),
                    SizedBox(width: 8.0),
                    Column(
                      children: [Text('${widgetProduct!.name}')],
                    ),
                  ],
                ),
              )
            : Text(userId),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<Room>(
                future: createRoom(),
                builder: (context, snapshot) {
                  print(snapshot.error);
                  if (snapshot.hasData) {
                    return StreamBuilder<Iterable<Message>>(
                      stream: FirebaseCloudStorage().getMessage(
                        roomId: snapshot.data!.id,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          return ListView.builder(
                            reverse: true,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final messages =
                                  List<Message>.from(snapshot.data!);
                              return Align(
                                alignment: messages[index].authorId == userId
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 8.0),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 4.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        messages[index].text,
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      SizedBox(width: 8.0),
                                      Text(DateFormat.jm().format(
                                          messages[index].createdAt.toDate())),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return ListView();
                        }
                      },
                    );
                  } else {
                    return const Center(
                      child: const CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            // const MessageTextField(),
            FutureBuilder<Room>(
                future: createRoom(),
                builder: (context, snapshot) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Ketik pesan...',
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          onPressed: () {
                            final text = _textController.text;
                            final authorId = userId;
                            FirebaseCloudStorage().sendMessage(
                              text: text,
                              authorId: authorId,
                              roomId: snapshot.data!.id,
                            );
                          },
                          icon: const Icon(Icons.send),
                        ),
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  const MessageTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('Pesan');
  }
}

class MessageTextField extends StatelessWidget {
  const MessageTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Ketik pesan...',
          border: InputBorder.none,
          suffixIcon: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.send),
          ),
        ),
      ),
    );
  }
}
