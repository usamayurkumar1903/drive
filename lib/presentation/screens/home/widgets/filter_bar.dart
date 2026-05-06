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
          // Filter button
          _FilterButton(
            label: 'Filter',
            icon: Icons.tune_rounded,
            isActive: filter.hasActiveFilters,
            isDark: isDark,
            onTap: () => _showFilterSheet(context, ref),
          ),
          const SizedBox(width: 8),

          // Sort button
          _FilterButton(
            label: filter.sortBy.label.split(':').first,
            icon: Icons.sort_rounded,
            isActive: filter.sortBy != SortOption.featured,
            isDark: isDark,
            onTap: () => _showSortSheet(context, ref),
          ),

          const Spacer(),

          // Active filters count badge
          if (filter.hasActiveFilters) ...[
            GestureDetector(
              onTap: () => ref.read(filterProvider.notifier).reset(),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppColors.error.withOpacity(0.3), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.close_rounded,
                        size: 12, color: AppColors.error),
                    const SizedBox(width: 4),
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

          // Grid / List toggle
          GestureDetector(
            onTap: onToggleView,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? AppColors.darkCard : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.25 : 0.07),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                isGridView
                    ? Icons.view_list_rounded
                    : Icons.grid_view_rounded,
                size: 18,
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: isActive
              ? const LinearGradient(colors: AppColors.goldGradient)
              : null,
          color: isActive ? null : isDark ? AppColors.darkCard : Colors.white,
          boxShadow: [
            BoxShadow(
              color: isActive
                  ? AppColors.gold.withOpacity(0.3)
                  : Colors.black.withOpacity(isDark ? 0.2 : 0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isActive
                  ? const Color(0xFF0A0A0F)
                  : isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isActive
                    ? const Color(0xFF0A0A0F)
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

// ──────────────────────────────
// Sort Bottom Sheet
// ──────────────────────────────
class _SortSheet extends StatelessWidget {
  final bool isDark;
  final WidgetRef ref;

  const _SortSheet({required this.isDark, required this.ref});

  @override
  Widget build(BuildContext context) {
    final current = ref.watch(filterProvider).sortBy;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.textTertiaryDark : Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text('Sort By', style: AppTextStyles.h3(dark: isDark)),
          const SizedBox(height: 16),
          ...SortOption.values.map((opt) => _SortTile(
                option: opt,
                isSelected: opt == current,
                isDark: isDark,
                onTap: () {
                  ref.read(filterProvider.notifier).setSortBy(opt);
                  Navigator.pop(context);
                },
              )),
        ],
      ),
    );
  }
}

class _SortTile extends StatelessWidget {
  final SortOption option;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _SortTile({
    required this.option,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: isSelected
              ? AppColors.gold.withOpacity(0.12)
              : isDark
                  ? AppColors.darkCard
                  : AppColors.lightBg,
          border: isSelected
              ? Border.all(color: AppColors.gold.withOpacity(0.4), width: 1.5)
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                option.label,
                style: AppTextStyles.bodyMedium(dark: isDark).copyWith(
                  color: isSelected
                      ? AppColors.gold
                      : isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.gold, size: 20),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────
// Filter Bottom Sheet
// ──────────────────────────────
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
    _priceRange = RangeValues(
      f.minPrice ?? 0,
      f.maxPrice ?? _maxPrice,
    );
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
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
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
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.textTertiaryDark
                        : Colors.black12,
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
                      setState(() => _priceRange =
                          const RangeValues(0, _maxPrice));
                    },
                    child: Text('Reset All',
                        style: TextStyle(
                            fontFamily: 'Urbanist',
                            color: AppColors.gold,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Price Range
              Text('PRICE RANGE',
                  style: AppTextStyles.label(dark: isDark)
                      .copyWith(color: AppColors.gold)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${_priceRange.start.toInt() ~/ 1000}K',
                    style: AppTextStyles.bodyMedium(dark: isDark),
                  ),
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
                  activeTrackColor: AppColors.gold,
                  inactiveTrackColor: isDark
                      ? AppColors.darkCard
                      : AppColors.lightBg,
                  thumbColor: AppColors.gold,
                  overlayColor: AppColors.gold.withOpacity(0.2),
                  trackHeight: 4,
                ),
                child: RangeSlider(
                  values: _priceRange,
                  min: 0,
                  max: _maxPrice,
                  divisions: 100,
                  onChanged: (v) => setState(() => _priceRange = v),
                  onChangeEnd: (v) {
                    ref.read(filterProvider.notifier).setMinPrice(
                        v.start > 0 ? v.start : null);
                    ref.read(filterProvider.notifier).setMaxPrice(
                        v.end < _maxPrice ? v.end : null);
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Fuel Type
              Text('FUEL TYPE',
                  style: AppTextStyles.label(dark: isDark)
                      .copyWith(color: AppColors.gold)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: fuelTypes.map((ft) {
                  final isSelected = filter.fuelType == ft;
                  return GestureDetector(
                    onTap: () => ref
                        .read(filterProvider.notifier)
                        .setFuelType(isSelected ? null : ft),
                    child: _FilterChip(
                        label: ft, isSelected: isSelected, isDark: isDark),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Brand
              Text('BRAND',
                  style: AppTextStyles.label(dark: isDark)
                      .copyWith(color: AppColors.gold)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: brands.map((b) {
                  final isSelected = filter.brand == b;
                  return GestureDetector(
                    onTap: () => ref
                        .read(filterProvider.notifier)
                        .setBrand(isSelected ? null : b),
                    child: _FilterChip(
                        label: b, isSelected: isSelected, isDark: isDark),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Category
              Text('CATEGORY',
                  style: AppTextStyles.label(dark: isDark)
                      .copyWith(color: AppColors.gold)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((c) {
                  final isSelected = filter.category == c;
                  return GestureDetector(
                    onTap: () => ref
                        .read(filterProvider.notifier)
                        .setCategory(isSelected ? null : c),
                    child: _FilterChip(
                        label: c, isSelected: isSelected, isDark: isDark),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Apply
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isDark;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isSelected ? AppColors.gold.withOpacity(0.15) : null,
        gradient: isSelected
            ? null
            : LinearGradient(
                colors: isDark
                    ? [AppColors.darkCard, AppColors.darkCardElevated]
                    : [Colors.white, const Color(0xFFF8F8FC)],
              ),
        border: Border.all(
          color: isSelected
              ? AppColors.gold.withOpacity(0.5)
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
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected
              ? AppColors.gold
              : isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
        ),
      ),
    );
  }
}
