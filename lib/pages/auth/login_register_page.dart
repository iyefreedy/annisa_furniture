import 'package:annisa_furniture/constants/routes.dart';
import 'package:annisa_furniture/pages/auth/verification_page.dart';
import 'package:annisa_furniture/services/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'phone_number_page.dart';

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({Key? key}) : super(key: key);

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  late PageController _pageController;

  late TextEditingController _phoneController;
  late TextEditingController _otpController;

  final String dialCode = '+62';

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _phoneController = TextEditingController();
    _otpController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: ((context, state) {
        if (state is AuthStateCodeSent) {
          _pageController.animateToPage(
            1,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeIn,
          );
        } else if (state is AuthStateNeedsVerification ||
            state is AuthStateLoggedOut) {
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeIn,
          );
        }
      }),
      builder: (context, state) {
        debugPrint('state $state');
        return Stack(
          children: [
            SizedBox(
              width: size.width,
              height: size.height,
              child: PageView(
                controller: _pageController,
                children: [
                  PhoneNumberPage(
                    phoneController: _phoneController,
                  ),
                  VerificationPage(
                    otpController: _otpController,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FloatingActionButton(
                  child: const Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    if (_phoneController.text.isNotEmpty &&
                        state is AuthStateLoggedOut) {
                      context.read<AuthBloc>().add(
                          AuthEventSendVerificationCode(
                              dialCode + _phoneController.text));
                      _pageController.animateToPage(1,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeIn);
                    } else if (state is AuthStateCodeSent) {
                      final token = _otpController.text;

                      context.read<AuthBloc>().add(
                            AuthEventVerifyCode(
                                state.verificationId, int.parse(token)),
                          );
                    }
                  },
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
