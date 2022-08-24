import 'package:annisa_furniture/constants/routes.dart';
import 'package:annisa_furniture/models/product.dart';

import 'package:annisa_furniture/services/cloud/firebase_cloud_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListProductPage extends StatefulWidget {
  const ListProductPage({Key? key}) : super(key: key);

  @override
  State<ListProductPage> createState() => _ListProductPageState();
}

class _ListProductPageState extends State<ListProductPage> {
  late final FirebaseCloudStorage _productServices;

  @override
  void initState() {
    super.initState();
    _productServices = FirebaseCloudStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Products'),
        backgroundColor: Colors.orange.shade400,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(adminAddProductRoute);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder(
          stream: _productServices.allProducts(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.hasData) {
                  final allProducts = snapshot.data as Iterable<Product>;
                  return ProductListWidget(
                    allProducts: allProducts,
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              case ConnectionState.none:
                return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

class ProductListWidget extends StatelessWidget {
  const ProductListWidget({
    Key? key,
    required this.allProducts,
  }) : super(key: key);

  final Iterable<Product> allProducts;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final List<Product> products = allProducts.toList();
    NumberFormat currency = NumberFormat.currency(locale: 'id', symbol: 'Rp. ');

    return SizedBox(
      width: size.width,
      height: size.height,
      child: ListView.builder(
        itemCount: products.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.network(
              products[index].image![0],
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                );
              },
            ),
            title: Text(products[index].name!),
            subtitle: Text(currency.format(products[index].price)),
            onLongPress: () {},
            onTap: () {
              Navigator.of(context).pushNamed(
                'create-update-product',
                arguments: products[index],
              );
            },
          );
        },
      ),
    );
  }
}
