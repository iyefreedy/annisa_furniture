import 'package:annisa_furniture/pages/admin/admin_page.dart';
import 'package:annisa_furniture/pages/user/home/tabs/cart_tab.dart';
import 'package:annisa_furniture/pages/user/home/tabs/explore_tab.dart';
import 'package:annisa_furniture/pages/user/home/tabs/history_tab.dart';
import 'package:annisa_furniture/pages/user/home/tabs/profile_tab.dart';
import 'package:annisa_furniture/pages/user/home/tabs/room_page.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final List<Widget> _pages = [
    const ExploreTab(),
    const FavoriteTab(),
    const CartTab(),
    const ProfileTab(),
    const AdminPage(),
    const RoomPage(),
  ];
  final user = FirebaseAuth.instance.currentUser;
  final cloudUser = FirebaseFirestore.instance.collection('users');
  late final String role;

  int _selectedPages = 0;

  late final PageController _pageController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedPages,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark),
                label: 'Bookmark',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Keranjang',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            onTap: (value) {
              setState(
                () {
                  _selectedPages = value;
                  _pageController.animateToPage(
                    _selectedPages,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                },
              );
            }),
        body: SizedBox.expand(
          child: PageView(
            children: _pages,
            controller: _pageController,
          ),
        ),
      ),
    );
  }
}
