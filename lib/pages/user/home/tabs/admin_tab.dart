import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminTab extends StatelessWidget {
  const AdminTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return SafeArea(
      child: Container(
        child: TextButton(
          onPressed: () async {
            final cloudProducts =
                FirebaseFirestore.instance.collection('products');
            if (user != null) {
              final product = await cloudProducts.add({
                'name': 'Test 1',
                'category': 'kategori 1',
                'price': '192000',
              });
              final fetched = await product.get();
              if (fetched.data() != null) {
                final data = fetched.data();
                log(data?['name']);
              }
            }
          },
          child: Text('Connect'),
        ),
      ),
    );
  }
}
