import 'package:annisa_furniture/constants/routes.dart';
import 'package:annisa_furniture/pages/admin/admin_page.dart';
import 'package:annisa_furniture/services/auth/bloc/auth_bloc.dart';
import 'package:annisa_furniture/utils/dialogs/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text('Menu Admin'),
          actions: [
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout = await showLogOutDialog(context);

                    if (shouldLogout) {
                      context.read<AuthBloc>().add(AuthEventLogOut());
                    }
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem(
                    value: MenuAction.logout,
                    child: Text('Logout'),
                  )
                ];
              },
            )
          ],
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              ListTile(
                title: const Text('Daftar Produk'),
                leading: const Icon(Icons.list),
                onTap: () =>
                    Navigator.of(context).pushNamed(adminListProductRoute),
              ),
              ListTile(
                title: const Text('Data Pemesanan Produk'),
                leading: const Icon(Icons.history),
                onTap: () => Navigator.of(context).pushNamed(adminOrderRoute),
              ),
              ListTile(
                title: const Text('Data Penjualan Produk'),
                leading: const Icon(Icons.add_chart),
                onTap: () =>
                    Navigator.of(context).pushNamed(adminListProductRoute),
              ),
              ListTile(
                title: const Text('Data Pembeli'),
                leading: const Icon(Icons.person_search),
                onTap: () =>
                    Navigator.of(context).pushNamed(adminListProductRoute),
              ),
            ],
          ),
        )
      ],
    );
  }
}
