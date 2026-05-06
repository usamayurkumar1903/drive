// lib/presentation/screens/home/widgets/home_header.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/providers/car_provider.dart';

class HomeHeader extends ConsumerWidget {
  final VoidCallback onThemeToggle;
  final bool isDark;

  const HomeHeader({
    super.key,
    required this.onThemeToggle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favCount = ref.watch(favoritesProvider).length;

    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 16,
        20,
        12,
      ),
      child: Row(
        children: [
          // Logo & greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Luxury emblem
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: AppColors.goldGradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gold.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'L',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            color: Color(0xFF0A0A0F),
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'LUXDRIVE',
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                        letterSpacing: 3.0,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Discover extraordinary machines',
                  style: AppTextStyles.caption(dark: isDark),
                ),
              ],
            ),
          ),

          // Actions
          Row(
            children: [
              // Theme toggle
              _IconBtn(
                icon: isDark
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
                onTap: onThemeToggle,
                isDark: isDark,
              ),
              const SizedBox(width: 8),

              // Notifications (cosmetic)
              _IconBtn(
                icon: Icons.notifications_outlined,
                onTap: () {},
                isDark: isDark,
                badge: 3,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;
  final int? badge;

  const _IconBtn({
    required this.icon,
    required this.onTap,
    required this.isDark,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? AppColors.darkCard : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 20,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          if (badge != null)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.gold,
                ),
                child: Center(
                  child: Text(
                    '$badge',
                    style: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0A0A0F),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
