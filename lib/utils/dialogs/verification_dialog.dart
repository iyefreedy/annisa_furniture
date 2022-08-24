import 'package:annisa_furniture/utils/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

Future<String?> showVerificationDialog(BuildContext context) {
  TextEditingController _otpController = TextEditingController();
  return showGenericDialog<String>(
    context: context,
    title: 'Verify your phone number',
    content: Pinput(
      controller: _otpController,
      length: 6,
      closeKeyboardWhenCompleted: true,
    ),
    optionsBuilder: () => {'Yes': _otpController.text, 'Cancel': null},
  ).then((value) => value);
}
