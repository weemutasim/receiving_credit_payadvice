import 'package:intl/intl.dart';

final formatter = NumberFormat("#,##0.00", "en_US");

String dateformat({required DateTime date, required String type}) {
  switch (type) {
    case "db":
      return DateFormat('yyyy-MM-dd').format(date);
    case "dnsn":
      return DateFormat('dd MMM yyyy').format(date);
    case "dn":
      return DateFormat('dd-MM-yyyy').format(date);
    case "dsn":
      return DateFormat('dd/MM/yyyy').format(date);
    case 'dmy':
      return DateFormat('ddMMyy').format(date);
    default:
      return date.toString();
  }
}

String formatThaiDate(DateTime date) {
  final buddhistYear = date.year + 543;
  final thaiMonths = [
    '', 'มกราคม', 'กุมภาพันธ์', 'มีนาคม', 'เมษายน', 'พฤษภาคม', 'มิถุนายน',
    'กรกฎาคม', 'สิงหาคม', 'กันยายน', 'ตุลาคม', 'พฤศจิกายน', 'ธันวาคม'
  ];

  final day = DateFormat('dd').format(date);
  final month = thaiMonths[date.month];
  return '$day $month $buddhistYear';
}