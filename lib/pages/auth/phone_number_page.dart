import 'package:annisa_furniture/services/auth/bloc/auth_bloc.dart';
import 'package:annisa_furniture/widgets/rounded_button.dart';
import 'package:annisa_furniture/widgets/rounded_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhoneNumberPage extends StatelessWidget {
  final TextEditingController phoneController;

  const PhoneNumberPage({Key? key, required this.phoneController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Login/Register',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Image.asset(
                  'assets/images/illustration-1.png',
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Masukkan nomor telepon untuk melanjutkan, kami akan mengirimkan kode OTP untuk melanjutkan.',
                  ),
                ),
                const SizedBox(height: 15.0),
                RoundedTextField(
                  controller: phoneController,
                  hintText: '123456789',
                  prefixIcon: const Icon(Icons.phone),
                  textInputType: TextInputType.number,
                  prefixText: '+62',
                ),
                // RoundedButton(
                //   text: 'Send Verification Code',
                //   onPressed: () async {},
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
