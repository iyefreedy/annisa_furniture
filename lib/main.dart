import 'package:annisa_furniture/constants/routes.dart';
import 'package:annisa_furniture/firebase_options.dart';
import 'package:annisa_furniture/pages/admin/admin_chat_page.dart';
import 'package:annisa_furniture/pages/admin/admin_order_page.dart';
import 'package:annisa_furniture/pages/admin/admin_sales_page.dart';
import 'package:annisa_furniture/pages/admin/create_update_product_page.dart';
import 'package:annisa_furniture/pages/admin/list_product_page.dart';
import 'package:annisa_furniture/pages/auth/login_register_page.dart';
import 'package:annisa_furniture/pages/chats/chat_page.dart';
import 'package:annisa_furniture/pages/home_page.dart';
import 'package:annisa_furniture/pages/order_page.dart';
import 'package:annisa_furniture/pages/product_page.dart';
import 'package:annisa_furniture/pages/user/home/user_page.dart';
import 'package:annisa_furniture/services/auth/bloc/auth_bloc.dart';
import 'package:annisa_furniture/services/auth/firebase_auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      routes: {
        loginOrRegisterRoute: (context) => const LoginRegisterPage(),
        homeRoute: (context) => const UserPage(),
        productRoute: (context) => const ProductPage(),
        orderRoute: (context) => const OrderPage(),
        adminListProductRoute: (context) => const ListProductPage(),
        adminAddProductRoute: (context) => const CreateUpdateProductPage(),
        adminCreateUpdateProductRoute: (context) =>
            const CreateUpdateProductPage(),
        productChatRoute: (context) => const ChatPage(),
        adminOrderRoute: (context) => const AdminOrderPage(),
        adminSalesRoute: (context) => const AdminSalesPage(),
        adminCustomerRoute: (context) => const AdminChatPage()
      },
      home: BlocProvider(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const InitialPage(),
      ),
    );
  }
}

class InitialPage extends StatelessWidget {
  const InitialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const HomePage();
        } else if (state is AuthStateLoggedOut || state is AuthStateCodeSent) {
          return const LoginRegisterPage();
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
