// lib/data/providers/currency_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyInfo {
  final String code;
  final String name;
  final String symbol;
  final double rateFromUSD;

  const CurrencyInfo({
    required this.code,
    required this.name,
    required this.symbol,
    required this.rateFromUSD,
  });
}

// Hardcoded rates relative to USD (updated periodically)
const List<CurrencyInfo> kAllCurrencies = [
  CurrencyInfo(code: 'USD', name: 'US Dollar', symbol: '\$', rateFromUSD: 1.0),
  CurrencyInfo(code: 'EUR', name: 'Euro', symbol: '€', rateFromUSD: 0.92),
  CurrencyInfo(code: 'GBP', name: 'British Pound', symbol: '£', rateFromUSD: 0.79),
  CurrencyInfo(code: 'AED', name: 'UAE Dirham', symbol: 'AED', rateFromUSD: 3.67),
  CurrencyInfo(code: 'INR', name: 'Indian Rupee', symbol: '₹', rateFromUSD: 83.5),
  CurrencyInfo(code: 'JPY', name: 'Japanese Yen', symbol: '¥', rateFromUSD: 149.5),
  CurrencyInfo(code: 'CNY', name: 'Chinese Yuan', symbol: '¥', rateFromUSD: 7.24),
  CurrencyInfo(code: 'SAR', name: 'Saudi Riyal', symbol: 'SAR', rateFromUSD: 3.75),
  CurrencyInfo(code: 'CHF', name: 'Swiss Franc', symbol: 'Fr', rateFromUSD: 0.90),
  CurrencyInfo(code: 'CAD', name: 'Canadian Dollar', symbol: 'CA\$', rateFromUSD: 1.36),
  CurrencyInfo(code: 'AUD', name: 'Australian Dollar', symbol: 'A\$', rateFromUSD: 1.53),
  CurrencyInfo(code: 'SGD', name: 'Singapore Dollar', symbol: 'S\$', rateFromUSD: 1.34),
  CurrencyInfo(code: 'KWD', name: 'Kuwaiti Dinar', symbol: 'KWD', rateFromUSD: 0.31),
  CurrencyInfo(code: 'QAR', name: 'Qatari Riyal', symbol: 'QAR', rateFromUSD: 3.64),
  CurrencyInfo(code: 'MYR', name: 'Malaysian Ringgit', symbol: 'RM', rateFromUSD: 4.73),
  CurrencyInfo(code: 'THB', name: 'Thai Baht', symbol: '฿', rateFromUSD: 35.1),
  CurrencyInfo(code: 'HKD', name: 'Hong Kong Dollar', symbol: 'HK\$', rateFromUSD: 7.82),
  CurrencyInfo(code: 'NZD', name: 'New Zealand Dollar', symbol: 'NZ\$', rateFromUSD: 1.63),
  CurrencyInfo(code: 'SEK', name: 'Swedish Krona', symbol: 'kr', rateFromUSD: 10.5),
  CurrencyInfo(code: 'NOK', name: 'Norwegian Krone', symbol: 'kr', rateFromUSD: 10.6),
  CurrencyInfo(code: 'DKK', name: 'Danish Krone', symbol: 'kr', rateFromUSD: 6.88),
  CurrencyInfo(code: 'PKR', name: 'Pakistani Rupee', symbol: '₨', rateFromUSD: 278.5),
  CurrencyInfo(code: 'BDT', name: 'Bangladeshi Taka', symbol: '৳', rateFromUSD: 110.0),
  CurrencyInfo(code: 'TRY', name: 'Turkish Lira', symbol: '₺', rateFromUSD: 32.2),
  CurrencyInfo(code: 'ZAR', name: 'South African Rand', symbol: 'R', rateFromUSD: 18.6),
  CurrencyInfo(code: 'BRL', name: 'Brazilian Real', symbol: 'R\$', rateFromUSD: 4.97),
  CurrencyInfo(code: 'MXN', name: 'Mexican Peso', symbol: 'MX\$', rateFromUSD: 17.2),
  CurrencyInfo(code: 'RUB', name: 'Russian Ruble', symbol: '₽', rateFromUSD: 91.5),
  CurrencyInfo(code: 'KRW', name: 'South Korean Won', symbol: '₩', rateFromUSD: 1325.0),
  CurrencyInfo(code: 'IDR', name: 'Indonesian Rupiah', symbol: 'Rp', rateFromUSD: 15800.0),
];

class CurrencyNotifier extends StateNotifier<CurrencyInfo> {
  CurrencyNotifier() : super(kAllCurrencies.first) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('currency_code') ?? 'USD';
    final found = kAllCurrencies.firstWhere(
      (c) => c.code == code,
      orElse: () => kAllCurrencies.first,
    );
    state = found;
  }

  Future<void> setCurrency(CurrencyInfo currency) async {
    state = currency;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency_code', currency.code);
  }

  String formatPrice(double usdPrice) {
    final converted = usdPrice * state.rateFromUSD;
    final symbol = state.symbol;

    if (converted >= 1000000) {
      return '$symbol${(converted / 1000000).toStringAsFixed(2)}M';
    } else if (converted >= 1000) {
      // Format with commas
      final formatted = converted.toStringAsFixed(0);
      final buf = StringBuffer();
      int count = 0;
      for (int i = formatted.length - 1; i >= 0; i--) {
        if (count > 0 && count % 3 == 0) buf.write(',');
        buf.write(formatted[i]);
        count++;
      }
      return '$symbol${buf.toString().split('').reversed.join()}';
    }
    return '$symbol${converted.toStringAsFixed(0)}';
  }
}

final currencyProvider =
    StateNotifierProvider<CurrencyNotifier, CurrencyInfo>(
        (_) => CurrencyNotifier());

// Helper to format price anywhere
final priceFormatterProvider = Provider<String Function(double)>((ref) {
  final notifier = ref.watch(currencyProvider.notifier);
  return notifier.formatPrice;
});
