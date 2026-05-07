// lib/presentation/screens/favorites/favorites_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/providers/car_provider.dart';
import '../../widgets/car_card/car_grid_card.dart';
import '../detail/car_detail_screen.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    final favCars = ref.watch(favoriteCarsProvider);

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBg : AppColors.lightBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).padding.top + 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SAVED',
                    style: AppTextStyles.label(dark: isDark)
                        .copyWith(color: AppColors.accent, fontSize: 11, letterSpacing: 2),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text('Wishlist',
                          style: AppTextStyles.h1(dark: isDark)),
                      const Spacer(),
                      if (favCars.isNotEmpty)
                        Text(
                          '${favCars.length} vehicles',
                          style: AppTextStyles.caption(dark: isDark),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          if (favCars.isEmpty)
            SliverFillRemaining(
              child: _EmptyFavorites(isDark: isDark),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final car = favCars[index];
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
                                builder: (_) =>
                                    CarDetailScreen(car: car),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: favCars.length,
                ),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.72,
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  final bool isDark;

  const _EmptyFavorites({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.error.withOpacity(0.08),
              border: Border.all(
                  color: AppColors.error.withOpacity(0.2), width: 2),
            ),
            child: const Icon(
              Icons.favorite_border_rounded,
              size: 44,
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: 24),
          Text('Your wishlist is empty',
              style: AppTextStyles.h3(dark: isDark)),
          const SizedBox(height: 8),
          Text(
            'Tap the heart icon on any car\nto save it here',
            style: AppTextStyles.body(dark: isDark),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
