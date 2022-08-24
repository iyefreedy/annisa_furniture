import 'package:annisa_furniture/constants/routes.dart';
import 'package:annisa_furniture/cubit/counter_cubit.dart';
import 'package:annisa_furniture/models/product.dart';
import 'package:annisa_furniture/services/auth/auth_service.dart';
import 'package:annisa_furniture/services/cloud/firebase_cloud_storage.dart';
import 'package:annisa_furniture/utils/generics/get_arguments.dart';
import 'package:annisa_furniture/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late final FirebaseCloudStorage firebaseCloudStorage;
  late int quantity;

  String get userId => AuthService.firebase().currentUser!.id;

  Future<Product> readProduct() async {
    final product = context.getArgument<Product>();

    final document =
        await firebaseCloudStorage.getProduct(productId: product!.id);

    return document;
  }

  @override
  void initState() {
    super.initState();
    quantity = 1;
    firebaseCloudStorage = FirebaseCloudStorage();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              final cloudProduct = await readProduct();
              Navigator.of(context)
                  .pushNamed(productChatRoute, arguments: cloudProduct);
            },
            icon: const Icon(Icons.chat),
          )
        ],
      ),
      body: FutureBuilder<Product>(
        future: readProduct(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
              final product = snapshot.data!;

              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  width: size.width,
                  height: size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductImage(product: product, size: size),
                      SizedBox(height: 10.0),
                      ProductCaption(product: product),
                      const SizedBox(height: 8.0),
                      ProductDescription(product: product),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(formatCurrency(product.price)),
                          BlocProvider(
                            create: (context) => CounterCubit(quantity),
                            child: BlocConsumer<CounterCubit, int>(
                              listener: (context, state) {
                                quantity = state;
                              },
                              builder: (context, state) {
                                return Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        context
                                            .read<CounterCubit>()
                                            .decrement();
                                      },
                                      icon: const Icon(Icons.remove),
                                    ),
                                    Text('$state'),
                                    IconButton(
                                      onPressed: () {
                                        context
                                            .read<CounterCubit>()
                                            .increment();
                                      },
                                      icon: const Icon(Icons.add),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () async {
                            final order = await firebaseCloudStorage.addOrder(
                              productId: product.id,
                              userId: userId,
                              quantity: quantity,
                            );

                            Navigator.of(context)
                                .pushNamed('/orders/', arguments: order);
                          },
                          child: Text('Pesan'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}

class ProductDescription extends StatelessWidget {
  const ProductDescription({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Text(
      product.description! + 'lorem ipsum dolor sdasd jwja fasfmx sw',
      style: const TextStyle(
        color: Colors.black54,
      ),
    );
  }
}

class ProductCaption extends StatelessWidget {
  const ProductCaption({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.poppins(
          color: Colors.black,
        ),
        children: [
          TextSpan(
            text: product.name!,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(
            text: '(${product.category})',
          )
        ],
      ),
    );
  }
}

class ProductImage extends StatelessWidget {
  const ProductImage({
    Key? key,
    required this.product,
    required this.size,
  }) : super(key: key);

  final Product product;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      product.image![0],
      width: size.width,
      height: size.height * .5,
      fit: BoxFit.cover,
    );
  }
}
