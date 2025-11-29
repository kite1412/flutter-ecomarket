import 'package:intl/intl.dart';

String formatRupiah(dynamic value) {
  if (value == null) return 'Rp. 0';
  num? numVal;
  if (value is num) {
    numVal = value;
  } else {
    numVal = num.tryParse(value.toString());
  }
  if (numVal == null) return 'Rp. 0';
  final formatter = NumberFormat.decimalPattern('id_ID');
  return 'Rp. ${formatter.format(numVal)}';
}
