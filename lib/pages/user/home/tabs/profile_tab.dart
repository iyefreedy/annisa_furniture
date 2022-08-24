import 'package:annisa_furniture/constants/routes.dart';
import 'package:annisa_furniture/services/auth/auth_service.dart';
import 'package:annisa_furniture/services/auth/bloc/auth_bloc.dart';
import 'package:annisa_furniture/services/cloud/firebase_cloud_storage.dart';
import 'package:annisa_furniture/utils/dialogs/logout_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late final FirebaseCloudStorage _cloudStorage;

  @override
  void initState() {
    _cloudStorage = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.firebase().currentUser;
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.orange.shade400,
            Colors.orange.shade400,
            Colors.orange.shade200,
          ],
        ),
      ),
      child: SafeArea(
        child: FutureBuilder(
          future: _cloudStorage.getUserRole(userId: user!.id),
          builder: (context, snapshot) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  foregroundColor: Colors.white,
                  title: const Text(
                    'Profile',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  actions: [
                    PopupMenuButton(
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            child: const Text('Logout'),
                            onTap: () async {
                              final shouldLogout =
                                  await showLogOutDialog(context);

                              if (shouldLogout) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  loginOrRegisterRoute,
                                  (route) => false,
                                );
                              }
                            },
                          )
                        ];
                      },
                    )
                  ],
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        height: size.height * .2,
                        margin: const EdgeInsets.only(
                          top: 40.0,
                        ),
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade200,
                        ),
                        padding: const EdgeInsets.all(.0),
                        foregroundDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 5.0,
                          ),
                        ),
                        child: user.photoUrl != null
                            ? Image.network(
                                user.photoUrl!,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              )
                            : Image.asset(
                                'assets/images/user-no-image.png',
                                fit: BoxFit.contain,
                              ),
                      ),
                      const SizedBox(height: 24.0),
                      Text(
                        user.displayName ?? 'undefined',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user.phoneNumber,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          top: 24.0,
                          left: 20.0,
                          right: 20.0,
                          bottom: 50.0,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(40.0),
                            topLeft: Radius.circular(40.0),
                          ),
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            const Text(
                              'Account Overview',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            ListTile(
                              title: const Text('My Profile'),
                              leading: const Icon(Icons.person),
                              iconColor: Colors.blue,
                              trailing: const Icon(
                                Icons.chevron_right,
                                color: Colors.grey,
                              ),
                              onTap: () {
                                Navigator.of(context).pushNamed(profileRoute);
                              },
                            ),
                            const ListTile(
                              title: Text('My Orders'),
                              leading: Icon(Icons.shopping_cart),
                              iconColor: Colors.green,
                              trailing: Icon(
                                Icons.chevron_right,
                                color: Colors.grey,
                              ),
                            ),
                            ListTile(
                              title: const Text('Logout'),
                              leading: const Icon(Icons.exit_to_app),
                              iconColor: Colors.pink,
                              trailing: const Icon(
                                Icons.chevron_right,
                                color: Colors.grey,
                              ),
                              onTap: () async {
                                final shouldLogout =
                                    await showLogOutDialog(context);

                                if (shouldLogout) {
                                  context
                                      .read<AuthBloc>()
                                      .add(AuthEventLogOut());
                                }
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
