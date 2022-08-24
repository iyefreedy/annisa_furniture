import 'package:annisa_furniture/models/order.dart';
import 'package:annisa_furniture/utils/generics/get_arguments.dart';
import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  Future<Order> getOrderUser() async {
    final widgetOrder = context.getArgument<Order>();

    if (widgetOrder != null) {
      return widgetOrder;
    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getOrderUser(),
        builder: (context, snapshot) {
          return Center(
            child: Text('${snapshot.data}'),
          );
        },
      ),
    );
  }
}
