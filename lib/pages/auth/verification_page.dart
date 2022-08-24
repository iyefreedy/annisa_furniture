import 'package:annisa_furniture/constants/routes.dart';
import 'package:annisa_furniture/services/auth/bloc/auth_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/rounded_textfield.dart';

class VerificationPage extends StatelessWidget {
  final TextEditingController otpController;

  const VerificationPage({Key? key, required this.otpController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: SingleChildScrollView(
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: size.width * .85,
                      child: const Text(
                        'Verification',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/images/illustration-2.png',
                      width: size.width * 0.8,
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      'Harap masukkan 6 digit angka yang sudah dikirimkan ke nomor anda',
                      textAlign: TextAlign.center,
                    ),
                    RoundedTextField(
                      controller: otpController,
                      hintText: 'Enter verification code',
                      prefixIcon: const Icon(Icons.numbers),
                      textInputType: TextInputType.number,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
