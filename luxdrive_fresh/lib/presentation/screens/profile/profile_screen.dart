// lib/presentation/screens/profile/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/providers/car_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    final favCount = ref.watch(favoritesProvider).length;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ── Header ─────────────────────────
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).padding.top + 20, 20, 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [AppColors.darkSurface, AppColors.darkCard]
                      : [Colors.white, const Color(0xFFF5F5F7)],
                ),
              ),
              child: Column(
                children: [
                  // Avatar
                  Stack(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
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
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'A',
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0A0A0F),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.gold,
                            border: Border.all(
                                color: isDark
                                    ? AppColors.darkSurface
                                    : Colors.white,
                                width: 2),
                          ),
                          child: const Icon(
                            Icons.edit_rounded,
                            size: 12,
                            color: Color(0xFF0A0A0F),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Alex Mercer',
                      style: AppTextStyles.h2(dark: isDark)),
                  const SizedBox(height: 4),
                  Text('alex.mercer@luxdrive.com',
                      style: AppTextStyles.body(dark: isDark)
                          .copyWith(fontSize: 13)),
                  const SizedBox(height: 20),

                  // Stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _StatBox(
                          label: 'Saved',
                          value: '$favCount',
                          isDark: isDark),
                      Container(
                        width: 1,
                        height: 40,
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        color: isDark
                            ? AppColors.darkCardElevated
                            : Colors.black12,
                      ),
                      _StatBox(
                          label: 'Test Drives',
                          value: '3',
                          isDark: isDark),
                      Container(
                        width: 1,
                        height: 40,
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        color: isDark
                            ? AppColors.darkCardElevated
                            : Colors.black12,
                      ),
                      _StatBox(
                          label: 'Reviews', value: '12', isDark: isDark),
                    ],
                  ),
                ],
              ),
            ),

            // ── Membership Badge ──────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(
                    colors: AppColors.goldGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gold.withOpacity(0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.workspace_premium_rounded,
                        color: Color(0xFF0A0A0F), size: 28),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PLATINUM MEMBER',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            color: Color(0xFF0A0A0F),
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Exclusive benefits & priority service',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 12,
                            color: Color(0x990A0A0F),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A0A0F).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Active',
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0A0A0F),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Settings Sections ─────────────────
            _SettingsSection(
              title: 'Preferences',
              isDark: isDark,
              children: [
                _SettingsTile(
                  icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  label: 'Dark Mode',
                  isDark: isDark,
                  trailing: Switch.adaptive(
                    value: isDark,
                    onChanged: (_) => ref
                        .read(isDarkModeProvider.notifier)
                        .state = !isDark,
                    activeColor: AppColors.gold,
                  ),
                ),
                _SettingsTile(
                  icon: Icons.notifications_rounded,
                  label: 'Notifications',
                  isDark: isDark,
                  trailing: Switch.adaptive(
                    value: true,
                    onChanged: (_) {},
                    activeColor: AppColors.gold,
                  ),
                ),
                _SettingsTile(
                  icon: Icons.currency_exchange_rounded,
                  label: 'Currency',
                  isDark: isDark,
                  value: 'USD',
                ),
                _SettingsTile(
                  icon: Icons.language_rounded,
                  label: 'Language',
                  isDark: isDark,
                  value: 'English',
                ),
              ],
            ),

            _SettingsSection(
              title: 'Account',
              isDark: isDark,
              children: [
                _SettingsTile(
                  icon: Icons.person_rounded,
                  label: 'Edit Profile',
                  isDark: isDark,
                  showArrow: true,
                ),
                _SettingsTile(
                  icon: Icons.lock_rounded,
                  label: 'Privacy & Security',
                  isDark: isDark,
                  showArrow: true,
                ),
                _SettingsTile(
                  icon: Icons.credit_card_rounded,
                  label: 'Payment Methods',
                  isDark: isDark,
                  showArrow: true,
                ),
                _SettingsTile(
                  icon: Icons.history_rounded,
                  label: 'Order History',
                  isDark: isDark,
                  showArrow: true,
                ),
              ],
            ),

            _SettingsSection(
              title: 'Support',
              isDark: isDark,
              children: [
                _SettingsTile(
                  icon: Icons.help_rounded,
                  label: 'Help Center',
                  isDark: isDark,
                  showArrow: true,
                ),
                _SettingsTile(
                  icon: Icons.star_rounded,
                  label: 'Rate the App',
                  isDark: isDark,
                  showArrow: true,
                ),
                _SettingsTile(
                  icon: Icons.info_rounded,
                  label: 'About LuxDrive',
                  isDark: isDark,
                  value: 'v1.0.0',
                ),
              ],
            ),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Sign Out',
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const _StatBox(
      {required this.label, required this.value, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.h2(dark: isDark).copyWith(
            color: AppColors.gold,
            fontSize: 26,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.caption(dark: isDark)),
      ],
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool isDark;

  const _SettingsSection({
    required this.title,
    required this.children,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: AppTextStyles.label(dark: isDark)
                .copyWith(color: AppColors.gold, fontSize: 10, letterSpacing: 2),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: isDark ? AppColors.darkCard : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.25 : 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: children.asMap().entries.map((e) {
                final last = e.key == children.length - 1;
                return Column(
                  children: [
                    e.value,
                    if (!last)
                      Divider(
                        height: 1,
                        indent: 56,
                        color: isDark
                            ? AppColors.darkCardElevated
                            : Colors.black.withOpacity(0.05),
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final String? value;
  final Widget? trailing;
  final bool showArrow;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.isDark,
    this.value,
    this.trailing,
    this.showArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.gold.withOpacity(0.1),
            ),
            child: Icon(icon, size: 16, color: AppColors.gold),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label,
                style: AppTextStyles.bodyMedium(dark: isDark)
                    .copyWith(fontSize: 14)),
          ),
          if (trailing != null) trailing!,
          if (value != null)
            Text(
              value!,
              style: AppTextStyles.caption(dark: isDark)
                  .copyWith(fontSize: 13),
            ),
          if (showArrow) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : Colors.black26,
            ),
          ],
        ],
      ),
    );
  }
}
