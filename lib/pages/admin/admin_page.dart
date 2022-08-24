import 'package:annisa_furniture/constants/routes.dart';
import 'package:annisa_furniture/pages/admin/admin_chat_page.dart';
import 'package:annisa_furniture/pages/admin/admin_dashboard_page.dart';
import 'package:annisa_furniture/pages/user/home/tabs/room_page.dart';
import 'package:annisa_furniture/services/auth/bloc/auth_bloc.dart';
import 'package:annisa_furniture/utils/dialogs/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum MenuAction { logout }

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _pages = [
    const AdminDashboardPage(),
    const AdminChatPage(),
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Pesan',
          )
        ],
      ),
      body: _pages.elementAt(selectedIndex),
    );
  }
}
