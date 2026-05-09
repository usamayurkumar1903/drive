// lib/presentation/screens/detail/car_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/providers/currency_provider.dart';
import '../../../data/models/car_model.dart';
import '../../../data/providers/car_provider.dart';

class CarDetailScreen extends ConsumerStatefulWidget {
  final CarModel car;

  const CarDetailScreen({super.key, required this.car});

  @override
  ConsumerState<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends ConsumerState<CarDetailScreen>
    with SingleTickerProviderStateMixin {
  final _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _fabController;
  late Animation<double> _fabAnim;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fabAnim = CurvedAnimation(parent: _fabController, curve: Curves.elasticOut);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _fabController.forward();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkModeProvider);
    final isFav =
        ref.watch(favoritesProvider).contains(widget.car.id);

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBg : AppColors.lightBg,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Hero Image + Carousel ──────────
              SliverToBoxAdapter(
                child: _ImageCarousel(
                  car: widget.car,
                  pageController: _pageController,
                  currentPage: _currentPage,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  isFav: isFav,
                  onFavToggle: () => ref
                      .read(favoritesProvider.notifier)
                      .toggle(widget.car.id),
                  isDark: isDark,
                ),
              ),

              // ── Main Content ───────────────────
              SliverToBoxAdapter(
                child: _DetailContent(car: widget.car, isDark: isDark),
              ),

              // Spacer for FAB
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),

          // ── Back Button ───────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            child: _GlassButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => Navigator.pop(context),
            ),
          ),

          // ── Share Button ──────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            right: 16,
            child: _GlassButton(
              icon: Icons.ios_share_rounded,
              onTap: () => _share(context),
            ),
          ),

          // ── Bottom CTA ────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _BottomCta(
              car: widget.car,
              fabAnim: _fabAnim,
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }

  void _share(BuildContext context) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${widget.car.name}…'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.darkCard,
      ),
    );
  }
}

// ──────────────────────────────
// Image Carousel
// ──────────────────────────────
class _ImageCarousel extends StatelessWidget {
  final CarModel car;
  final PageController pageController;
  final int currentPage;
  final ValueChanged<int> onPageChanged;
  final bool isFav;
  final VoidCallback onFavToggle;
  final bool isDark;

  const _ImageCarousel({
    required this.car,
    required this.pageController,
    required this.currentPage,
    required this.onPageChanged,
    required this.isFav,
    required this.onFavToggle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Page view
        SizedBox(
          height: 380,
          child: PageView.builder(
            controller: pageController,
            onPageChanged: onPageChanged,
            itemCount: car.galleryImages.length,
            itemBuilder: (context, index) {
              final isFirst = index == 0;
              return isFirst
                  ? Hero(
                      tag: 'car_image_${car.id}',
                      child: _CarImage(
                          imagePath: car.galleryImages[index],
                          brand: car.brand,
                          isDark: isDark),
                    )
                  : _CarImage(
                      imagePath: car.galleryImages[index],
                      brand: car.brand,
                      isDark: isDark);
            },
          ),
        ),

        // Gradient overlay bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 120,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  isDark ? AppColors.darkBg : AppColors.lightBg,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Page indicator
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                car.galleryImages.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: currentPage == i ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: currentPage == i ? AppColors.accent : Colors.white38,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Favorite button (top-right of image)
        Positioned(
          bottom: 24,
          right: 20,
          child: _FavButton(isFav: isFav, onTap: onFavToggle),
        ),

        // Fuel type badge
        Positioned(
          bottom: 26,
          left: 20,
          child: _FuelTypePill(fuelType: car.specs.fuelType),
        ),
      ],
    );
  }
}

class _CarImage extends StatelessWidget {
  final String imagePath;
  final String brand;
  final bool isDark;

  const _CarImage({
    required this.imagePath,
    required this.brand,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      width: double.infinity,
      height: 380,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color:
            isDark ? AppColors.darkCardElevated : const Color(0xFFEEEEF5),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.directions_car_filled_rounded,
                size: 72,
                color: isDark
                    ? AppColors.textTertiaryDark
                    : Colors.black26,
              ),
              const SizedBox(height: 12),
              Text(brand,
                  style: AppTextStyles.h3(dark: isDark)
                      .copyWith(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────
// Detail Content
// ──────────────────────────────
class _DetailContent extends ConsumerWidget {
  final CarModel car;
  final bool isDark;

  const _DetailContent({required this.car, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand + Year
          Row(
            children: [
              Text(
                car.brand.toUpperCase(),
                style: AppTextStyles.label(dark: isDark)
                    .copyWith(color: AppColors.accent, fontSize: 11, letterSpacing: 2),
              ),
              const SizedBox(width: 8),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? AppColors.textTertiaryDark
                      : Colors.black26,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                car.year,
                style: AppTextStyles.label(dark: isDark).copyWith(fontSize: 11),
              ),
              const SizedBox(width: 8),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? AppColors.textTertiaryDark
                      : Colors.black26,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                car.category,
                style: AppTextStyles.label(dark: isDark).copyWith(fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Name + Price Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  car.name,
                  style: AppTextStyles.display(dark: isDark).copyWith(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    ref.watch(currencyProvider.notifier).formatPrice(car.price),
                    style: AppTextStyles.price(dark: isDark).copyWith(fontSize: 22),
                  ),
                  Text(
                    'MSRP',
                    style: AppTextStyles.label(dark: isDark).copyWith(
                      fontSize: 9,
                      color: isDark
                          ? AppColors.textTertiaryDark
                          : Colors.black38,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Rating Row
          _RatingRow(car: car, isDark: isDark),
          const SizedBox(height: 20),

          // Quick Spec Pills
          _QuickSpecs(car: car, isDark: isDark),
          const SizedBox(height: 28),

          // Available Colors
          _ColorsSection(car: car, isDark: isDark),
          const SizedBox(height: 28),

          // Description
          _Section(
            title: 'About',
            isDark: isDark,
            child: Text(
              car.description,
              style: AppTextStyles.body(dark: isDark).copyWith(height: 1.7),
            ),
          ),
          const SizedBox(height: 28),

          // Full Specs
          _Section(
            title: 'Specifications',
            isDark: isDark,
            child: _SpecsGrid(car: car, isDark: isDark),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _RatingRow extends StatelessWidget {
  final CarModel car;
  final bool isDark;

  const _RatingRow({required this.car, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(5, (i) {
          final filled = i < car.rating.floor();
          final half = !filled && i < car.rating;
          return Padding(
            padding: const EdgeInsets.only(right: 2),
            child: Icon(
              half
                  ? Icons.star_half_rounded
                  : filled
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
              color: AppColors.accent,
              size: 16,
            ),
          );
        }),
        const SizedBox(width: 8),
        Text(
          '${car.rating.toStringAsFixed(1)} (${car.reviewCount} reviews)',
          style: AppTextStyles.caption(dark: isDark)
              .copyWith(fontSize: 12),
        ),
      ],
    );
  }
}

class _QuickSpecs extends StatelessWidget {
  final CarModel car;
  final bool isDark;

  const _QuickSpecs({required this.car, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final specs = [
      ('0–100', car.specs.acceleration, Icons.speed_rounded),
      ('Power', car.specs.horsepower, Icons.flash_on_rounded),
      ('Top', car.specs.topSpeed, Icons.trending_up_rounded),
      (
        car.specs.fuelType == 'Electric' ? 'Range' : 'Tank',
        car.specs.fuelType == 'Electric'
            ? car.specs.range
            : car.specs.fuelConsumption,
        car.specs.fuelType == 'Electric'
            ? Icons.bolt_rounded
            : Icons.local_gas_station_rounded,
      ),
    ];

    return Row(
      children: specs.map((s) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: s == specs.last ? 0 : 10),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [AppColors.darkCard, AppColors.darkCardElevated]
                    : [Colors.white, const Color(0xFFF8F8FC)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(s.$3, color: AppColors.accent, size: 20),
                const SizedBox(height: 6),
                Text(
                  s.$2,
                  style: AppTextStyles.bodyMedium(dark: isDark).copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  s.$1,
                  style: AppTextStyles.label(dark: isDark)
                      .copyWith(fontSize: 9),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ColorsSection extends StatefulWidget {
  final CarModel car;
  final bool isDark;

  const _ColorsSection({required this.car, required this.isDark});

  @override
  State<_ColorsSection> createState() => _ColorsSectionState();
}

class _ColorsSectionState extends State<_ColorsSection> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('AVAILABLE COLORS',
                style: AppTextStyles.label(dark: widget.isDark)
                    .copyWith(color: AppColors.accent, fontSize: 10)),
            const Spacer(),
            Text(
              '${widget.car.colors.length} options',
              style: AppTextStyles.caption(dark: widget.isDark),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: widget.car.colors.asMap().entries.map((e) {
            final i = e.key;
            final hex = e.value;
            final color = Color(
              int.parse(hex.replaceFirst('#', 'FF'), radix: 16),
            );
            final isSelected = _selected == i;
            return GestureDetector(
              onTap: () => setState(() => _selected = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 10),
                width: isSelected ? 36 : 28,
                height: isSelected ? 36 : 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.accent
                        : Colors.transparent,
                    width: 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.5),
                      blurRadius: isSelected ? 12 : 4,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  final bool isDark;

  const _Section({
    required this.title,
    required this.child,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: AppColors.accentGradient,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            Text(title, style: AppTextStyles.h3(dark: isDark)),
          ],
        ),
        const SizedBox(height: 14),
        child,
      ],
    );
  }
}

class _SpecsGrid extends StatelessWidget {
  final CarModel car;
  final bool isDark;

  const _SpecsGrid({required this.car, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final specs = [
      ('Engine', car.specs.engine),
      ('Horsepower', car.specs.horsepower),
      ('Torque', car.specs.torque),
      ('0–100 km/h', car.specs.acceleration),
      ('Top Speed', car.specs.topSpeed),
      ('Transmission', car.specs.transmission),
      ('Drivetrain', car.specs.drivetrain),
      ('Fuel Type', car.specs.fuelType),
      ('Consumption', car.specs.fuelConsumption),
      ('Seating', car.specs.seating),
      ('Weight', car.specs.weight),
      if (car.specs.range != 'N/A') ('Range', car.specs.range),
    ];

    return Column(
      children: specs
          .asMap()
          .entries
          .map(
            (e) => _SpecRow(
              label: e.value.$1,
              value: e.value.$2,
              isDark: isDark,
              isEven: e.key.isEven,
            ),
          )
          .toList(),
    );
  }
}

class _SpecRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final bool isEven;

  const _SpecRow({
    required this.label,
    required this.value,
    required this.isDark,
    required this.isEven,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isEven
            ? (isDark ? AppColors.darkCard : Colors.white)
            : Colors.transparent,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTextStyles.body(dark: isDark).copyWith(
                  fontSize: 13,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppTextStyles.bodyMedium(dark: isDark).copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────
// Bottom CTA
// ──────────────────────────────
class _BottomCta extends StatelessWidget {
  final CarModel car;
  final Animation<double> fabAnim;
  final bool isDark;

  const _BottomCta({
    required this.car,
    required this.fabAnim,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: fabAnim,
      child: Container(
        padding: EdgeInsets.fromLTRB(
            20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.5 : 0.1),
              blurRadius: 30,
              offset: const Offset(0, -10),
            ),
          ],
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Row(
          children: [
            // Test Drive
            Expanded(
              child: GestureDetector(
                onTap: () => _showBooking(context, isDark),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: AppColors.accent.withOpacity(0.5), width: 1.5),
                    color: AppColors.accent.withOpacity(0.08),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.directions_car_rounded,
                          color: AppColors.accent, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Test Drive',
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          color: AppColors.accent,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Buy Now
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () => _showPurchase(context, car, isDark),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: AppColors.accentGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag_rounded,
                          color: Color(0xFF0A0A0F), size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Buy Now',
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          color: Color(0xFF0A0A0F),
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBooking(BuildContext context, bool isDark) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _BookingSheet(car: car, isDark: isDark),
    );
  }

  void _showPurchase(BuildContext context, CarModel car, bool isDark) {
    HapticFeedback.heavyImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _PurchaseSheet(car: car, isDark: isDark),
    );
  }
}

// ──────────────────────────────
// Booking Sheet
// ──────────────────────────────
class _BookingSheet extends StatelessWidget {
  final CarModel car;
  final bool isDark;

  const _BookingSheet({required this.car, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          24, 8, 24, MediaQuery.of(context).padding.bottom + 24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.textTertiaryDark : Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Row(
            children: [
              const Icon(Icons.event_available_rounded,
                  color: AppColors.accent, size: 24),
              const SizedBox(width: 12),
              Text('Book a Test Drive',
                  style: AppTextStyles.h3(dark: isDark)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${car.brand} ${car.name} · ${car.year}',
            style: AppTextStyles.body(dark: isDark),
          ),
          const SizedBox(height: 24),
          _InfoTile(
              icon: Icons.location_on_rounded,
              title: 'Nearest Showroom',
              subtitle: '2.4 km · Downtown Luxury Auto',
              isDark: isDark),
          const SizedBox(height: 12),
          _InfoTile(
              icon: Icons.calendar_month_rounded,
              title: 'Next Available',
              subtitle: 'Tomorrow · 10:00 AM – 6:00 PM',
              isDark: isDark),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        const Text('Test drive request sent! We\'ll call you shortly.'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: const Text('Confirm Booking'),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────
// Purchase Sheet
// ──────────────────────────────
class _PurchaseSheet extends ConsumerWidget {
  final CarModel car;
  final bool isDark;

  const _PurchaseSheet({required this.car, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          24, 8, 24, MediaQuery.of(context).padding.bottom + 24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.textTertiaryDark : Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Row(
            children: [
              const Icon(Icons.verified_rounded,
                  color: AppColors.accent, size: 24),
              const SizedBox(width: 12),
              Text('Purchase Summary', style: AppTextStyles.h3(dark: isDark)),
            ],
          ),
          const SizedBox(height: 20),
          _PriceLine(
              label: 'Vehicle Price',
              value: ref.watch(currencyProvider.notifier).formatPrice(car.price),
              isDark: isDark),
          _PriceLine(
              label: 'Documentation',
              value: '\$1,500',
              isDark: isDark),
          _PriceLine(
              label: 'Delivery & Setup',
              value: 'Complimentary',
              isDark: isDark,
              valueColor: AppColors.success),
          const SizedBox(height: 8),
          Divider(
              color: isDark ? AppColors.darkCard : Colors.black12,
              thickness: 1),
          const SizedBox(height: 8),
          _PriceLine(
            label: 'Total',
            value: ref.watch(currencyProvider.notifier).formatPrice(car.price + 1500),
            isDark: isDark,
            isBold: true,
            valueColor: AppColors.accent,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                        'Order placed! Your advisor will contact you within 24 hours.'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: const Text('Place Order'),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Secure checkout · Finance options available',
            style: AppTextStyles.caption(dark: isDark),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _PriceLine extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final bool isBold;
  final Color? valueColor;

  const _PriceLine({
    required this.label,
    required this.value,
    required this.isDark,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            label,
            style: AppTextStyles.body(dark: isDark).copyWith(
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
              color: isBold
                  ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)
                  : null,
              fontSize: isBold ? 16 : 14,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTextStyles.bodyMedium(dark: isDark).copyWith(
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              color: valueColor ??
                  (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
              fontSize: isBold ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDark;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: isDark ? AppColors.darkCard : AppColors.lightBg,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accent.withOpacity(0.12),
            ),
            child: Icon(icon, color: AppColors.accent, size: 18),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: AppTextStyles.bodyMedium(dark: isDark)
                      .copyWith(fontSize: 13)),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: AppTextStyles.caption(dark: isDark)),
            ],
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────
// Misc Helpers
// ──────────────────────────────
class _GlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.45),
          border: Border.all(
              color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}

class _FavButton extends StatelessWidget {
  final bool isFav;
  final VoidCallback onTap;

  const _FavButton({required this.isFav, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isFav
              ? AppColors.error.withOpacity(0.15)
              : Colors.black.withOpacity(0.4),
          border: Border.all(
            color: isFav
                ? AppColors.error.withOpacity(0.6)
                : Colors.white.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: isFav
              ? [
                  BoxShadow(
                      color: AppColors.error.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4))
                ]
              : [],
        ),
        child: Icon(
          isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: isFav ? AppColors.error : Colors.white,
          size: 22,
        ),
      ),
    );
  }
}

class _FuelTypePill extends StatelessWidget {
  final String fuelType;

  const _FuelTypePill({required this.fuelType});

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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black.withOpacity(0.5),
        border: Border.all(color: color.withOpacity(0.6), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Text(
            fuelType,
            style: TextStyle(
              fontFamily: 'Urbanist',
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
