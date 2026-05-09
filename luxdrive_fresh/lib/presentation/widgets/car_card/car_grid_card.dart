// lib/presentation/widgets/car_card/car_grid_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/providers/currency_provider.dart';
import '../../../data/models/car_model.dart';
import '../../../data/providers/car_provider.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Grid Card
// ──────────────────────────────────────────────────────────────────────────────
class CarGridCard extends ConsumerStatefulWidget {
  final CarModel car;
  final VoidCallback onTap;
  final int index;

  const CarGridCard({
    super.key,
    required this.car,
    required this.onTap,
    this.index = 0,
  });

  @override
  ConsumerState<CarGridCard> createState() => _CarGridCardState();
}

class _CarGridCardState extends ConsumerState<CarGridCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.96).animate(
        CurvedAnimation(parent: _pressCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFav = ref.watch(favoritesProvider).contains(widget.car.id);
    final isDark = ref.watch(isDarkModeProvider);

    return ScaleTransition(
      scale: _scaleAnim,
      child: GestureDetector(
        onTapDown: (_) => _pressCtrl.forward(),
        onTapUp: (_) => _pressCtrl.reverse(),
        onTapCancel: () => _pressCtrl.reverse(),
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: isDark ? AppColors.darkCard : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      Hero(
                        tag: 'car_image_${widget.car.id}',
                        child: Container(
                          width: double.infinity,
                          color: isDark
                              ? AppColors.darkCardElevated
                              : const Color(0xFFF0F0F5),
                          child: Image.asset(
                            widget.car.imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _PlaceholderImage(brand: widget.car.brand, isDark: isDark),
                          ),
                        ),
                      ),
                      // Gradient overlay
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 50,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                (isDark ? AppColors.darkCard : Colors.white)
                                    .withOpacity(0.7),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      // NEW badge
                      if (widget.car.isNew)
                        Positioned(
                          top: 10,
                          left: 10,
                          child: _Badge(label: 'NEW', color: AppColors.success),
                        ),
                      // Fuel badge - top right, no overlap with heart
                      Positioned(
                        top: 10,
                        right: 44,
                        child: _FuelBadge(fuelType: widget.car.specs.fuelType),
                      ),
                      // Favorite button - top right corner
                      Positioned(
                        top: 6,
                        right: 6,
                        child: _FavoriteButton(
                          isFavorite: isFav,
                          onTap: () => ref
                              .read(favoritesProvider.notifier)
                              .toggle(widget.car.id),
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                ),
                // Info
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.car.brand.toUpperCase(),
                              style: AppTextStyles.label(dark: isDark).copyWith(
                                color: AppColors.accent,
                                fontSize: 9,
                                letterSpacing: 1.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.car.name,
                              style: AppTextStyles.h3(dark: isDark).copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                ref.watch(currencyProvider.notifier).formatPrice(widget.car.price),
                                style: AppTextStyles.bodyMedium(dark: isDark)
                                    .copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded,
                                    color: AppColors.warning, size: 11),
                                const SizedBox(width: 2),
                                Text(
                                  widget.car.rating.toStringAsFixed(1),
                                  style: AppTextStyles.caption(dark: isDark)
                                      .copyWith(fontSize: 10),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// List Card
// ──────────────────────────────────────────────────────────────────────────────
class CarListCard extends ConsumerStatefulWidget {
  final CarModel car;
  final VoidCallback onTap;

  const CarListCard({super.key, required this.car, required this.onTap});

  @override
  ConsumerState<CarListCard> createState() => _CarListCardState();
}

class _CarListCardState extends ConsumerState<CarListCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    _scale = Tween(begin: 1.0, end: 0.97)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFav = ref.watch(favoritesProvider).contains(widget.car.id);
    final isDark = ref.watch(isDarkModeProvider);

    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTapDown: (_) => _ctrl.forward(),
        onTapUp: (_) => _ctrl.reverse(),
        onTapCancel: () => _ctrl.reverse(),
        onTap: widget.onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isDark ? AppColors.darkCard : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.25 : 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Row(
              children: [
                // Image
                Hero(
                  tag: 'car_image_${widget.car.id}',
                  child: SizedBox(
                    width: 120,
                    height: 95,
                    child: Image.asset(
                      widget.car.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _PlaceholderImage(
                          brand: widget.car.brand, isDark: isDark),
                    ),
                  ),
                ),
                // Info
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.car.brand.toUpperCase(),
                                    style: AppTextStyles.label(dark: isDark)
                                        .copyWith(
                                            color: AppColors.accent,
                                            fontSize: 9,
                                            letterSpacing: 1.5),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    widget.car.name,
                                    style: AppTextStyles.h3(dark: isDark)
                                        .copyWith(fontSize: 14),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            _FavoriteButton(
                              isFavorite: isFav,
                              onTap: () => ref
                                  .read(favoritesProvider.notifier)
                                  .toggle(widget.car.id),
                              size: 30,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            _SpecChip(
                              icon: Icons.speed_rounded,
                              label: widget.car.specs.acceleration,
                              isDark: isDark,
                            ),
                            const SizedBox(width: 6),
                            _SpecChip(
                              icon: Icons.bolt_rounded,
                              label: widget.car.specs.horsepower,
                              isDark: isDark,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          ref.watch(currencyProvider.notifier).formatPrice(widget.car.price),
                          style: AppTextStyles.bodyMedium(dark: isDark)
                              .copyWith(
                                  fontSize: 15, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Featured Card
// ──────────────────────────────────────────────────────────────────────────────
class FeaturedCarCard extends ConsumerWidget {
  final CarModel car;
  final VoidCallback onTap;

  const FeaturedCarCard({super.key, required this.car, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(favoritesProvider).contains(car.id);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            children: [
              Hero(
                tag: 'car_image_${car.id}',
                child: SizedBox.expand(
                  child: Image.asset(
                    car.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        _PlaceholderImage(brand: car.brand, isDark: true),
                  ),
                ),
              ),
              // Gradient
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Color(0x880F0F0F),
                      Color(0xEE0F0F0F),
                    ],
                    stops: [0.3, 0.6, 1.0],
                  ),
                ),
              ),
              // Content
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (car.isNew)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: _Badge(
                              label: 'NEW', color: AppColors.success),
                        ),
                      Text(
                        car.brand.toUpperCase(),
                        style: const TextStyle(
                          fontFamily: 'Urbanist',
                          color: AppColors.accent,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.8,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        car.name,
                        style: const TextStyle(
                          fontFamily: 'Urbanist',
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            ref.watch(currencyProvider.notifier).formatPrice(car.price),
                            style: const TextStyle(
                              fontFamily: 'Urbanist',
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Spacer(),
                          _MiniSpec(
                              icon: Icons.speed_rounded,
                              label: car.specs.acceleration),
                          const SizedBox(width: 8),
                          _MiniSpec(
                              icon: Icons.flash_on_rounded,
                              label: car.specs.horsepower),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Fav button
              Positioned(
                top: 12,
                right: 12,
                child: _FavoriteButton(
                  isFavorite: isFav,
                  onTap: () =>
                      ref.read(favoritesProvider.notifier).toggle(car.id),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ──────────────────────────────────────────────────────────────────────────────
class _FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onTap;
  final double size;

  const _FavoriteButton({
    required this.isFavorite,
    required this.onTap,
    this.size = 34,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isFavorite
              ? AppColors.error.withOpacity(0.15)
              : Colors.black.withOpacity(0.25),
          border: Border.all(
            color: isFavorite
                ? AppColors.error.withOpacity(0.5)
                : Colors.white.withOpacity(0.25),
            width: 1,
          ),
        ),
        child: Icon(
          isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: isFavorite ? AppColors.error : Colors.white.withOpacity(0.85),
          size: size * 0.48,
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Urbanist',
          color: color,
          fontSize: 8,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _FuelBadge extends StatelessWidget {
  final String fuelType;
  const _FuelBadge({required this.fuelType});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    switch (fuelType) {
      case 'Electric':
        color = AppColors.success;
        icon = Icons.bolt_rounded;
      case 'Hybrid':
        color = const Color(0xFF30B0C7);
        icon = Icons.eco_rounded;
      default:
        color = AppColors.warning;
        icon = Icons.local_gas_station_rounded;
    }
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.15),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Icon(icon, color: color, size: 11),
    );
  }
}

class _SpecChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  const _SpecChip(
      {required this.icon, required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardElevated : AppColors.lightBg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 10,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight),
          const SizedBox(width: 3),
          Text(
            label,
            style: AppTextStyles.caption(dark: isDark)
                .copyWith(fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _MiniSpec extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MiniSpec({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: AppColors.accent),
        const SizedBox(width: 3),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Urbanist',
            color: Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  final String brand;
  final bool isDark;
  const _PlaceholderImage({required this.brand, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDark ? AppColors.darkCardElevated : const Color(0xFFEEEEF5),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.directions_car_filled_rounded,
              size: 36,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : AppColors.textTertiaryLight,
            ),
            const SizedBox(height: 6),
            Text(brand, style: AppTextStyles.caption(dark: isDark)),
          ],
        ),
      ),
    );
  }
}
