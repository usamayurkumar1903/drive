// lib/presentation/widgets/car_card/car_grid_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/car_model.dart';
import '../../../data/providers/car_provider.dart';

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
  late AnimationController _pressController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFav = ref.watch(favoritesProvider).contains(widget.car.id);
    final isDark = ref.watch(isDarkModeProvider);

    return ScaleTransition(
      scale: _scaleAnim,
      child: GestureDetector(
        onTapDown: (_) => _pressController.forward(),
        onTapUp: (_) => _pressController.reverse(),
        onTapCancel: () => _pressController.reverse(),
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [AppColors.darkCard, AppColors.darkCardElevated]
                  : [Colors.white, const Color(0xFFF8F8FC)],
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.4)
                    : Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      // Car image
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
                            errorBuilder: (_, __, ___) => _PlaceholderImage(
                              brand: widget.car.brand,
                              isDark: isDark,
                            ),
                          ),
                        ),
                      ),

                      // Gradient overlay
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 60,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                isDark
                                    ? AppColors.darkCard.withOpacity(0.8)
                                    : Colors.white.withOpacity(0.6),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),

                      // NEW badge
                      if (widget.car.isNew)
                        Positioned(
                          top: 12,
                          left: 12,
                          child: _Badge(label: 'NEW', color: AppColors.success),
                        ),

                      // Fuel type badge
                      Positioned(
                        top: 12,
                        right: 44,
                        child: _FuelBadge(fuelType: widget.car.specs.fuelType),
                      ),

                      // Favorite button
                      Positioned(
                        top: 8,
                        right: 8,
                        child: _FavoriteButton(
                          isFavorite: isFav,
                          onTap: () => ref
                              .read(favoritesProvider.notifier)
                              .toggle(widget.car.id),
                        ),
                      ),
                    ],
                  ),
                ),

                // Info
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
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
                                color: AppColors.gold,
                                fontSize: 10,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.car.name,
                              style: AppTextStyles.h3(dark: isDark).copyWith(
                                fontSize: 14,
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
                            Text(
                              Formatters.formatPrice(widget.car.price),
                              style: AppTextStyles.price().copyWith(
                                fontSize: 16,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  color: AppColors.gold,
                                  size: 12,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  widget.car.rating.toStringAsFixed(1),
                                  style: AppTextStyles.caption(dark: isDark)
                                      .copyWith(fontSize: 11),
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

// ──────────────────────────────
// List card (horizontal)
// ──────────────────────────────
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
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isDark ? AppColors.darkCard : Colors.white,
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.35)
                    : Colors.black.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Row(
              children: [
                // Image
                Hero(
                  tag: 'car_image_${widget.car.id}',
                  child: SizedBox(
                    width: 130,
                    height: 100,
                    child: Image.asset(
                      widget.car.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _PlaceholderImage(
                        brand: widget.car.brand,
                        isDark: isDark,
                      ),
                    ),
                  ),
                ),

                // Info
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
                                            color: AppColors.gold, fontSize: 10),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    widget.car.name,
                                    style:
                                        AppTextStyles.h3(dark: isDark).copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
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
                              size: 32,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
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
                        const SizedBox(height: 8),
                        Text(
                          Formatters.formatPrice(widget.car.price),
                          style: AppTextStyles.price().copyWith(fontSize: 17),
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

// ──────────────────────────────
// Featured Card (large horizontal scroll)
// ──────────────────────────────
class FeaturedCarCard extends ConsumerWidget {
  final CarModel car;
  final VoidCallback onTap;

  const FeaturedCarCard({super.key, required this.car, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(favoritesProvider).contains(car.id);
    final isDark = ref.watch(isDarkModeProvider);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 30,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              // Background image
              Hero(
                tag: 'car_image_${car.id}',
                child: SizedBox.expand(
                  child: Image.asset(
                    car.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _PlaceholderImage(
                      brand: car.brand,
                      isDark: true,
                    ),
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
                      Color(0x660A0A0F),
                      Color(0xEE0A0A0F),
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
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (car.isNew)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _Badge(
                              label: 'NEW ARRIVAL', color: AppColors.success),
                        ),
                      Text(
                        car.brand.toUpperCase(),
                        style: AppTextStyles.label().copyWith(
                          color: AppColors.gold,
                          fontSize: 11,
                          letterSpacing: 2.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        car.name,
                        style: AppTextStyles.h2(dark: true),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            Formatters.formatPrice(car.price),
                            style: AppTextStyles.price(),
                          ),
                          const Spacer(),
                          Row(children: [
                            _MiniSpec(
                                icon: Icons.speed_rounded,
                                label: car.specs.acceleration),
                            const SizedBox(width: 10),
                            _MiniSpec(
                                icon: Icons.flash_on_rounded,
                                label: car.specs.horsepower),
                          ]),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Favorite btn
              Positioned(
                top: 14,
                right: 14,
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

// ──────────────────────────────
// Sub-widgets
// ──────────────────────────────
class _FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onTap;
  final double size;

  const _FavoriteButton({
    required this.isFavorite,
    required this.onTap,
    this.size = 36,
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
              : Colors.black.withOpacity(0.3),
          border: Border.all(
            color: isFavorite
                ? AppColors.error.withOpacity(0.5)
                : Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Icon(
          isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: isFavorite ? AppColors.error : Colors.white.withOpacity(0.8),
          size: size * 0.5,
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Urbanist',
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
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
        color = const Color(0xFF34C759);
        icon = Icons.bolt_rounded;
      case 'Hybrid':
        color = const Color(0xFF30B0C7);
        icon = Icons.eco_rounded;
      default:
        color = const Color(0xFFFF9F0A);
        icon = Icons.local_gas_station_rounded;
    }

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.15),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Icon(icon, color: color, size: 12),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkCardElevated
            : AppColors.lightBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 11,
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
        Icon(icon, size: 12, color: AppColors.gold),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.caption(dark: true)
              .copyWith(color: Colors.white70, fontSize: 11),
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
              size: 40,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : AppColors.textSecondaryLight.withOpacity(0.4),
            ),
            const SizedBox(height: 8),
            Text(
              brand,
              style: AppTextStyles.caption(dark: isDark),
            ),
          ],
        ),
      ),
    );
  }
}
