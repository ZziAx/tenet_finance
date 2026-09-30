import 'package:intl/intl.dart' as intl;
import 'package:persian_number_utility/persian_number_utility.dart';

String formatPrice(dynamic number) {
  return (number is num ? number.toString() : number)
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',')
      .replaceAllMapped(
        RegExp(r'[0-9]'),
        (match) => '۰۱۲۳۴۵۶۷۸۹'[int.parse(match.group(0)!)],
      );
}

String generateCharacter(
  int length, {
  String prefix = '',
  String suffix = '',
  String char = '*',
}) {
  int subLength = prefix.trim().length + suffix.trim().length;
  if (subLength > length) {
    return prefix + suffix;
  }

  return  suffix+List.generate(length - subLength, (i) => '*').join() + prefix;
}

String formatCardNumber(String text) {
  return text
      .replaceAllMapped(RegExp(r'.{1,4}'), (match) => '${match.group(0)}-')
      .replaceFirst(RegExp(r'-$'), '')
      .toPersianDigit();
}

String formatNumber(String value) {
  final buffer = StringBuffer();

  for (int i = 0; i < value.length; i++) {
    if (i > 0 && (value.length - i) % 3 == 0) {
      buffer.write(',');
    }

    buffer.write(value[i]);
  }

  return buffer.toString();
}
