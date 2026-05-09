// lib/core/utils/formatters.dart

class Formatters {
  static String formatPrice(double price) {
    if (price >= 1000000) {
      return '\$${(price / 1000000).toStringAsFixed(1)}M';
    }
    // format with commas
    final s = price.toStringAsFixed(0);
    final buf = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buf.write(',');
      buf.write(s[i]);
      count++;
    }
    return '\$${buf.toString().split('').reversed.join()}';
  }

  static String formatPriceFull(double price) => formatPrice(price);

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
