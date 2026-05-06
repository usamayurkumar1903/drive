// lib/presentation/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/providers/car_provider.dart';
import '../../widgets/car_card/car_grid_card.dart';
import '../detail/car_detail_screen.dart';
import 'widgets/home_header.dart';
import 'widgets/filter_bar.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/featured_section.dart';
import 'widgets/brand_filter_row.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isGridView = true;
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkModeProvider);
    final filteredCars = ref.watch(filteredCarsProvider);
    final isSearchActive = ref.watch(isSearchActiveProvider);

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBg : AppColors.lightBg,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── App Bar ──────────────────────────
          SliverToBoxAdapter(
            child: HomeHeader(
              onThemeToggle: () => ref
                  .read(isDarkModeProvider.notifier)
                  .state = !isDark,
              isDark: isDark,
            ),
          ),

          // ── Search Bar ──────────────────────
          const SliverToBoxAdapter(child: SearchBarWidget()),

          // ── Featured Section ─────────────────
          if (!isSearchActive) ...[
            SliverToBoxAdapter(
              child: _SectionHeader(
                title: 'Featured',
                subtitle: 'Handpicked for you',
                isDark: isDark,
              ),
            ),
            const SliverToBoxAdapter(child: FeaturedSection()),

            // ── Brand Filter ──────────────────
            SliverToBoxAdapter(
              child: _SectionHeader(
                title: 'Browse',
                subtitle: 'By brand',
                isDark: isDark,
                showBrandFilter: true,
              ),
            ),
            const SliverToBoxAdapter(child: BrandFilterRow()),
          ],

          // ── Filter & Sort Bar ─────────────────
          SliverPersistentHeader(
            pinned: true,
            delegate: _FilterBarDelegate(
              child: FilterBar(
                isGridView: _isGridView,
                onToggleView: () => setState(() => _isGridView = !_isGridView),
                isDark: isDark,
              ),
            ),
          ),

          // ── Results Count ─────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: Text(
                '${filteredCars.length} vehicles found',
                style: AppTextStyles.caption(dark: isDark),
              ),
            ),
          ),

          // ── Car Grid / List ───────────────────
          if (filteredCars.isEmpty)
            SliverFillRemaining(
              child: _EmptyState(isDark: isDark),
            )
          else if (_isGridView)
            _GridView(cars: filteredCars)
          else
            _ListView(cars: filteredCars),

          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }
}

// ──────────────────────────────
// Grid View Sliver
// ──────────────────────────────
class _GridView extends StatelessWidget {
  final List cars;

  const _GridView({required this.cars});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final car = cars[index];
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 400),
              columnCount: 2,
              child: ScaleAnimation(
                scale: 0.92,
                child: FadeInAnimation(
                  child: CarGridCard(
                    car: car,
                    index: index,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CarDetailScreen(car: car),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          childCount: cars.length,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 0.72,
        ),
      ),
    );
  }
}

// ──────────────────────────────
// List View Sliver
// ──────────────────────────────
class _ListView extends StatelessWidget {
  final List cars;

  const _ListView({required this.cars});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final car = cars[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 350),
            child: SlideAnimation(
              verticalOffset: 30,
              child: FadeInAnimation(
                child: CarListCard(
                  car: car,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CarDetailScreen(car: car),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        childCount: cars.length,
      ),
    );
  }
}

// ──────────────────────────────
// Section Header
// ──────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isDark;
  final bool showBrandFilter;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.isDark,
    this.showBrandFilter = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle.toUpperCase(),
            style: AppTextStyles.label(dark: isDark)
                .copyWith(color: AppColors.gold, fontSize: 10),
          ),
          const SizedBox(height: 4),
          Text(title, style: AppTextStyles.h2(dark: isDark)),
        ],
      ),
    );
  }
}

// ──────────────────────────────
// Empty State
// ──────────────────────────────
class _EmptyState extends StatelessWidget {
  final bool isDark;

  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 72,
            color: isDark
                ? AppColors.textTertiaryDark
                : AppColors.textSecondaryLight.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'No vehicles found',
            style: AppTextStyles.h3(dark: isDark),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or search query',
            style: AppTextStyles.body(dark: isDark),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────
// Pinned filter bar delegate
// ──────────────────────────────
class _FilterBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _FilterBarDelegate({required this.child});

  @override
  double get minExtent => 60;
  @override
  double get maxExtent => 60;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(_FilterBarDelegate oldDelegate) => true;
}
