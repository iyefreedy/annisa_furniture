import 'package:annisa_furniture/pages/admin/admin_page.dart';
import 'package:annisa_furniture/pages/user/home/user_page.dart';
import 'package:annisa_furniture/services/auth/auth_service.dart';
import 'package:annisa_furniture/services/cloud/firebase_cloud_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final users = FirebaseFirestore.instance.collection('users');

  Future<String?> restrictAccess() async {
    final user = AuthService.firebase().currentUser;

    if (user != null) {
      final role = await FirebaseCloudStorage().getUserRole(userId: user.id);
      return role;
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: restrictAccess(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          case ConnectionState.done:
            if (snapshot.hasData) {
              print('role : ${snapshot.data!}');
              final role = snapshot.data as String;

              switch (role) {
                case 'admin':
                  return const AdminPage();
                case 'user':
                  return const UserPage();
                default:
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
              }
            } else {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
        }
      },
    );
  }
}
