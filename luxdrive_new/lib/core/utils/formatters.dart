// lib/core/utils/formatters.dart

import 'package:intl/intl.dart';

class Formatters {
  static final _priceFormatter = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 0,
    locale: 'en_US',
  );

  static String formatPrice(double price) {
    if (price >= 1000000) {
      return '\$${(price / 1000000).toStringAsFixed(1)}M';
    }
    return _priceFormatter.format(price);
  }

  static String formatPriceFull(double price) => _priceFormatter.format(price);

  static String shortBrand(String brand) {
    const shorts = {
      'Mercedes-Benz': 'Mercedes',
      'Rolls-Royce': 'Rolls-Royce',
      'Land Rover': 'Land Rover',
      'Aston Martin': 'Aston Martin',
    };
    return shorts[brand] ?? brand;
  }
}
