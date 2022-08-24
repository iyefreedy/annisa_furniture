import 'package:annisa_furniture/models/order.dart';
import 'package:annisa_furniture/services/cloud/firebase_cloud_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminOrderPage extends StatefulWidget {
  const AdminOrderPage({Key? key}) : super(key: key);

  @override
  State<AdminOrderPage> createState() => _AdminOrderPageState();
}

class _AdminOrderPageState extends State<AdminOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Pemesanan'),
      ),
      body: StreamBuilder<List<Order>>(
        stream: FirebaseCloudStorage().allOrders(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final orders = snapshot.data!;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Order ID : ${orders[index].id}'),
                  subtitle: Text(
                      'Tanggal Pemesanan : ${DateFormat('d-M-y H:mm').format(orders[index].createdAt.toDate())}'),
                  trailing: PopupMenuButton<int>(
                    onSelected: (value) async {
                      switch (value) {
                        case 0:
                          await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Berhasil'),
                              content: Text('Pembayaran telah dikonfirmasi'),
                            ),
                          );
                      }
                    },
                    itemBuilder: (context) {
                      return const [
                        PopupMenuItem(
                          child: Text('Konfirmasi Pembayaran'),
                          value: 0,
                        )
                      ];
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
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
