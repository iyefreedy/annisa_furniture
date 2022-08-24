// ignore_for_file: unused_element

import 'package:annisa_furniture/constants/routes.dart';
import 'package:annisa_furniture/models/product.dart';
import 'package:annisa_furniture/services/cloud/firebase_cloud_storage.dart';
import 'package:annisa_furniture/utils/utilities.dart';
import 'package:flutter/material.dart';

class ExploreTab extends StatefulWidget {
  const ExploreTab({Key? key}) : super(key: key);

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  // final List<String> _banners = [
  //   'assets/images/banner1.jpg',
  //   'assets/images/banner2.jpg',
  //   'assets/images/banner3.jpg',
  // ];

  final List<String> _products = [
    'assets/images/product1.jpg',
    'assets/images/product2.jpg',
    'assets/images/product3.jpg',
    'assets/images/product4.jpg',
    'assets/images/product5.jpg',
    'assets/images/product6.jpg',
    'assets/images/product7.jpg',
    'assets/images/product8.jpg',
  ];

  late final PageController _pageController;
  late final FirebaseCloudStorage _firebaseCloudStorage;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _firebaseCloudStorage = FirebaseCloudStorage();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: CustomScrollView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Container(
              height: size.height * 0.05,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(999.0)),
              child: const TextField(
                autocorrect: false,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
                    hintText: 'Search E.g. Dining Table',
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.search)),
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.symmetric(vertical: 12.0)),
          SliverToBoxAdapter(
            child: StreamBuilder<Iterable<Product>>(
              stream: _firebaseCloudStorage.allProducts(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.active:
                  case ConnectionState.done:
                  case ConnectionState.waiting:
                    if (snapshot.hasData) {
                      print(snapshot.data);
                      final productsIterable =
                          snapshot.data as Iterable<Product>;
                      final products = productsIterable.toList();
                      return GridView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: products.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 8.0,
                            crossAxisSpacing: 4.0,
                          ),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  productRoute,
                                  arguments: products[index],
                                );
                              },
                              child: GridTile(
                                child: Image.network(
                                  products[index].image![0],
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                                footer: Container(
                                  color: Colors.blueAccent,
                                  child: Text(
                                    formatCurrency(products[index].price),
                                  ),
                                ),
                              ),
                            );
                          });
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }

                  case ConnectionState.none:
                    return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoProducts(Size size) {
    return SizedBox(
      height: 200.0,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 16.0),
        itemCount: _products.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return AspectRatio(
            aspectRatio: 0.8,
            child: Container(
              clipBehavior: Clip.hardEdge,
              margin: const EdgeInsets.only(right: 16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height * .15,
                    width: double.infinity,
                    child: Image.asset(_products[index], fit: BoxFit.cover),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Product $index',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text('Rp. 200.000',
                            style: Theme.of(context).textTheme.bodyText2),
                        const SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Padding _buildPromoText() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        'Promo',
        style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
