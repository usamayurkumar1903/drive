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

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkModeProvider);
    final filteredCars = ref.watch(filteredCarsProvider);
    final isSearchActive = ref.watch(isSearchActiveProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(
            child: HomeHeader(
              onThemeToggle: () =>
                  ref.read(isDarkModeProvider.notifier).state = !isDark,
              isDark: isDark,
            ),
          ),
          const SliverToBoxAdapter(child: SearchBarWidget()),
          if (!isSearchActive) ...[
            SliverToBoxAdapter(
              child: _SectionHeader(
                title: 'Featured',
                subtitle: 'Handpicked for you',
                isDark: isDark,
              ),
            ),
            const SliverToBoxAdapter(child: FeaturedSection()),
            SliverToBoxAdapter(
              child: _SectionHeader(
                title: 'Browse',
                subtitle: 'By brand',
                isDark: isDark,
              ),
            ),
            const SliverToBoxAdapter(child: BrandFilterRow()),
          ],
          SliverPersistentHeader(
            pinned: true,
            delegate: _FilterBarDelegate(
              child: FilterBar(
                isGridView: _isGridView,
                onToggleView: () =>
                    setState(() => _isGridView = !_isGridView),
                isDark: isDark,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Text(
                '${filteredCars.length} vehicles found',
                style: AppTextStyles.caption(dark: isDark),
              ),
            ),
          ),
          if (filteredCars.isEmpty)
            SliverFillRemaining(child: _EmptyState(isDark: isDark))
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
              duration: const Duration(milliseconds: 350),
              columnCount: 2,
              child: ScaleAnimation(
                scale: 0.94,
                child: FadeInAnimation(
                  child: RepaintBoundary(
                    child: CarGridCard(
                      car: car,
                      index: index,
                      onTap: () => Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) =>
                              CarDetailScreen(car: car),
                          transitionsBuilder: (_, anim, __, child) =>
                              FadeTransition(opacity: anim, child: child),
                          transitionDuration:
                              const Duration(milliseconds: 300),
                        ),
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
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
      ),
    );
  }
}

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
            duration: const Duration(milliseconds: 300),
            child: SlideAnimation(
              verticalOffset: 20,
              child: FadeInAnimation(
                child: RepaintBoundary(
                  child: CarListCard(
                    car: car,
                    onTap: () => Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) =>
                            CarDetailScreen(car: car),
                        transitionsBuilder: (_, anim, __, child) =>
                            FadeTransition(opacity: anim, child: child),
                        transitionDuration:
                            const Duration(milliseconds: 300),
                      ),
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

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isDark;
  const _SectionHeader(
      {required this.title, required this.subtitle, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle.toUpperCase(),
              style: AppTextStyles.label(dark: isDark)
                  .copyWith(color: AppColors.accent, fontSize: 10)),
          const SizedBox(height: 4),
          Text(title, style: AppTextStyles.h2(dark: isDark)),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isDark;
  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded,
              size: 64,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : AppColors.textTertiaryLight),
          const SizedBox(height: 16),
          Text('No vehicles found', style: AppTextStyles.h3(dark: isDark)),
          const SizedBox(height: 8),
          Text('Try adjusting your filters',
              style: AppTextStyles.body(dark: isDark)),
        ],
      ),
    );
  }
}

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
  bool shouldRebuild(_FilterBarDelegate old) => true;
}
