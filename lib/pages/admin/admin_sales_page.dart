import 'package:flutter/material.dart';

class AdminSalesPage extends StatefulWidget {
  const AdminSalesPage({Key? key}) : super(key: key);

  @override
  State<AdminSalesPage> createState() => _AdminSalesPageState();
}

class _AdminSalesPageState extends State<AdminSalesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Penjualan'),
      ),
      body: StreamBuilder(
        builder: (context, snapshot) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
