import 'package:intl/intl.dart';

final NumberFormat rupiahFormatter =
    NumberFormat.decimalPattern('id_ID');

String formatRupiah(num value) {
  return 'Rp ${rupiahFormatter.format(value)}';
}
