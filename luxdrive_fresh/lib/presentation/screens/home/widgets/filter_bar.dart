// lib/presentation/screens/home/widgets/filter_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/providers/car_provider.dart';

class FilterBar extends ConsumerWidget {
  final bool isGridView;
  final VoidCallback onToggleView;
  final bool isDark;

  const FilterBar({
    super.key,
    required this.isGridView,
    required this.onToggleView,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(filterProvider);

    return Container(
      height: 60,
      color: isDark ? AppColors.darkBg : AppColors.lightBg,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _FilterButton(
            label: 'Filter',
            icon: Icons.tune_rounded,
            isActive: filter.hasActiveFilters,
            isDark: isDark,
            onTap: () => _showFilterSheet(context, ref),
          ),
          const SizedBox(width: 8),
          _FilterButton(
            label: filter.sortBy.label.split(':').first,
            icon: Icons.sort_rounded,
            isActive: filter.sortBy != SortOption.featured,
            isDark: isDark,
            onTap: () => _showSortSheet(context, ref),
          ),
          const Spacer(),
          if (filter.hasActiveFilters) ...[
            GestureDetector(
              onTap: () => ref.read(filterProvider.notifier).reset(),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: AppColors.error.withOpacity(0.3), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.close_rounded,
                        size: 11, color: AppColors.error),
                    const SizedBox(width: 3),
                    Text(
                      'Clear',
                      style: AppTextStyles.caption(dark: isDark).copyWith(
                          color: AppColors.error, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          GestureDetector(
            onTap: onToggleView,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? AppColors.darkCard : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                isGridView
                    ? Icons.view_list_rounded
                    : Icons.grid_view_rounded,
                size: 17,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSortSheet(BuildContext context, WidgetRef ref) {
    final isDark = ref.read(isDarkModeProvider);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _SortSheet(isDark: isDark, ref: ref),
    );
  }

  void _showFilterSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _FilterSheet(ref: ref),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;

  const _FilterButton({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isActive
              ? AppColors.accent
              : isDark
                  ? AppColors.darkCard
                  : Colors.white,
          boxShadow: [
            BoxShadow(
              color: isActive
                  ? AppColors.accent.withOpacity(0.3)
                  : Colors.black.withOpacity(isDark ? 0.15 : 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isActive
                  ? Colors.white
                  : isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isActive
                    ? Colors.white
                    : isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sort Sheet ────────────────────────────────────────────────────────────────
class _SortSheet extends StatelessWidget {
  final bool isDark;
  final WidgetRef ref;
  const _SortSheet({required this.isDark, required this.ref});

  @override
  Widget build(BuildContext context) {
    final current = ref.watch(filterProvider).sortBy;
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 8, 20, MediaQuery.of(context).padding.bottom + 24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.textTertiaryDark : Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text('Sort By', style: AppTextStyles.h3(dark: isDark)),
          const SizedBox(height: 14),
          ...SortOption.values.map((opt) => GestureDetector(
                onTap: () {
                  ref.read(filterProvider.notifier).setSortBy(opt);
                  Navigator.pop(context);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 13),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: opt == current
                        ? AppColors.accent.withOpacity(0.1)
                        : isDark
                            ? AppColors.darkCard
                            : AppColors.lightBg,
                    border: opt == current
                        ? Border.all(
                            color: AppColors.accent.withOpacity(0.4),
                            width: 1.5)
                        : null,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          opt.label,
                          style: AppTextStyles.bodyMedium(dark: isDark)
                              .copyWith(
                            color: opt == current ? AppColors.accent : null,
                            fontWeight: opt == current
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                      if (opt == current)
                        const Icon(Icons.check_circle_rounded,
                            color: AppColors.accent, size: 18),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

// ── Filter Sheet ─────────────────────────────────────────────────────────────
class _FilterSheet extends ConsumerStatefulWidget {
  final WidgetRef ref;
  const _FilterSheet({required this.ref});

  @override
  ConsumerState<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<_FilterSheet> {
  late RangeValues _priceRange;
  static const double _maxPrice = 5000000;

  @override
  void initState() {
    super.initState();
    final f = ref.read(filterProvider);
    _priceRange = RangeValues(f.minPrice ?? 0, f.maxPrice ?? _maxPrice);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkModeProvider);
    final filter = ref.watch(filterProvider);
    final brands = ref.watch(carRepositoryProvider).getAllBrands();
    final categories = ref.watch(carRepositoryProvider).getAllCategories();
    final fuelTypes = ['Petrol', 'Electric', 'Hybrid'];

    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 8, 20, MediaQuery.of(context).padding.bottom + 20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 1,
        minChildSize: 1,
        maxChildSize: 1,
        builder: (_, ctrl) => SingleChildScrollView(
          controller: ctrl,
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.textTertiaryDark : Colors.black12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  Text('Filters', style: AppTextStyles.h2(dark: isDark)),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      ref.read(filterProvider.notifier).reset();
                      setState(() =>
                          _priceRange = const RangeValues(0, _maxPrice));
                    },
                    child: Text('Reset',
                        style: TextStyle(
                            fontFamily: 'Urbanist',
                            color: AppColors.accent,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('PRICE RANGE',
                  style: AppTextStyles.label(dark: isDark)
                      .copyWith(color: AppColors.accent, fontSize: 10)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('\$${_priceRange.start.toInt() ~/ 1000}K',
                      style: AppTextStyles.bodyMedium(dark: isDark)),
                  Text(
                    _priceRange.end >= _maxPrice
                        ? 'No limit'
                        : '\$${(_priceRange.end / 1000).toStringAsFixed(0)}K',
                    style: AppTextStyles.bodyMedium(dark: isDark),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: AppColors.accent,
                  inactiveTrackColor:
                      isDark ? AppColors.darkCard : AppColors.lightBg,
                  thumbColor: AppColors.accent,
                  overlayColor: AppColors.accent.withOpacity(0.15),
                  trackHeight: 3,
                ),
                child: RangeSlider(
                  values: _priceRange,
                  min: 0,
                  max: _maxPrice,
                  divisions: 100,
                  onChanged: (v) => setState(() => _priceRange = v),
                  onChangeEnd: (v) {
                    ref
                        .read(filterProvider.notifier)
                        .setMinPrice(v.start > 0 ? v.start : null);
                    ref
                        .read(filterProvider.notifier)
                        .setMaxPrice(v.end < _maxPrice ? v.end : null);
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text('FUEL TYPE',
                  style: AppTextStyles.label(dark: isDark)
                      .copyWith(color: AppColors.accent, fontSize: 10)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: fuelTypes.map((ft) {
                  final sel = filter.fuelType == ft;
                  return GestureDetector(
                    onTap: () => ref
                        .read(filterProvider.notifier)
                        .setFuelType(sel ? null : ft),
                    child: _Chip(label: ft, isSelected: sel, isDark: isDark),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text('BRAND',
                  style: AppTextStyles.label(dark: isDark)
                      .copyWith(color: AppColors.accent, fontSize: 10)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: brands.map((b) {
                  final sel = filter.brand == b;
                  return GestureDetector(
                    onTap: () => ref
                        .read(filterProvider.notifier)
                        .setBrand(sel ? null : b),
                    child: _Chip(label: b, isSelected: sel, isDark: isDark),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text('CATEGORY',
                  style: AppTextStyles.label(dark: isDark)
                      .copyWith(color: AppColors.accent, fontSize: 10)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((c) {
                  final sel = filter.category == c;
                  return GestureDetector(
                    onTap: () => ref
                        .read(filterProvider.notifier)
                        .setCategory(sel ? null : c),
                    child: _Chip(label: c, isSelected: sel, isDark: isDark),
                  );
                }).toList(),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isDark;
  const _Chip(
      {required this.label, required this.isSelected, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isSelected ? AppColors.accent.withOpacity(0.12) : null,
        border: Border.all(
          color: isSelected
              ? AppColors.accent.withOpacity(0.5)
              : isDark
                  ? AppColors.darkCardElevated
                  : Colors.black12,
          width: 1.5,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Urbanist',
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected
              ? AppColors.accent
              : isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
        ),
      ),
    );
  }
}
