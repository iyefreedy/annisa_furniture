import 'package:annisa_furniture/utils/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Sign out',
    content: const Text('Are you sure want to log out ?'),
    optionsBuilder: () => {'Yes': true, 'Cancel': false},
  ).then(
    (value) => value ?? false,
  );
}
