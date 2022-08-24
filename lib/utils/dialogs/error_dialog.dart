import 'package:annisa_furniture/utils/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog(
    context: context,
    title: 'An error occured',
    content: Text(text),
    optionsBuilder: () => {'OK': null},
  );
}
