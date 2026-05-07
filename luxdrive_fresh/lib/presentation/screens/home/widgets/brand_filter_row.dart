// lib/presentation/screens/home/widgets/brand_filter_row.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/providers/car_provider.dart';

class BrandFilterRow extends ConsumerWidget {
  const BrandFilterRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brands = ref.watch(carRepositoryProvider).getAllBrands();
    final selectedBrand = ref.watch(filterProvider).brand;
    final isDark = ref.watch(isDarkModeProvider);

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        itemCount: brands.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          if (i == 0) {
            return _BrandChip(
              label: 'All',
              isSelected: selectedBrand == null,
              isDark: isDark,
              onTap: () => ref.read(filterProvider.notifier).setBrand(null),
            );
          }
          final brand = brands[i - 1];
          return _BrandChip(
            label: brand,
            isSelected: selectedBrand == brand,
            isDark: isDark,
            onTap: () => ref
                .read(filterProvider.notifier)
                .setBrand(selectedBrand == brand ? null : brand),
          );
        },
      ),
    );
  }
}

class _BrandChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _BrandChip({
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected
              ? AppColors.accent
              : isDark
                  ? AppColors.darkCard
                  : Colors.white,
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.accent.withOpacity(0.3)
                  : Colors.black.withOpacity(isDark ? 0.15 : 0.05),
              blurRadius: isSelected ? 10 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? Colors.white
                : isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
          ),
        ),
      ),
    );
  }
}
