import 'package:intl/intl.dart';

String formatCurrency(dynamic text) {
  return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ').format(text);
}

// String formatTimeMessage() {}
