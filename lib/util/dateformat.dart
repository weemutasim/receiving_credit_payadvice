import 'package:intl/intl.dart';

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
    default:
      return date.toString();
  }
}