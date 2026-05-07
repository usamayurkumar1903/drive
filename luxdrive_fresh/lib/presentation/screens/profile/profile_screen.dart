// lib/presentation/screens/profile/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/providers/car_provider.dart';

// ── Providers ─────────────────────────────────────────────────────────────────
final selectedCurrencyProvider = StateProvider<String>((_) => 'USD');
final selectedLanguageProvider = StateProvider<String>((_) => 'English');

const List<Map<String, String>> kCurrencies = [
  {'code': 'USD', 'name': 'US Dollar', 'symbol': '\$'},
  {'code': 'EUR', 'name': 'Euro', 'symbol': '€'},
  {'code': 'GBP', 'name': 'British Pound', 'symbol': '£'},
  {'code': 'AED', 'name': 'UAE Dirham', 'symbol': 'د.إ'},
  {'code': 'INR', 'name': 'Indian Rupee', 'symbol': '₹'},
  {'code': 'JPY', 'name': 'Japanese Yen', 'symbol': '¥'},
  {'code': 'CNY', 'name': 'Chinese Yuan', 'symbol': '¥'},
  {'code': 'SAR', 'name': 'Saudi Riyal', 'symbol': 'ر.س'},
  {'code': 'CHF', 'name': 'Swiss Franc', 'symbol': 'Fr'},
  {'code': 'CAD', 'name': 'Canadian Dollar', 'symbol': 'C\$'},
  {'code': 'AUD', 'name': 'Australian Dollar', 'symbol': 'A\$'},
  {'code': 'SGD', 'name': 'Singapore Dollar', 'symbol': 'S\$'},
  {'code': 'KWD', 'name': 'Kuwaiti Dinar', 'symbol': 'د.ك'},
  {'code': 'QAR', 'name': 'Qatari Riyal', 'symbol': 'ر.ق'},
  {'code': 'MYR', 'name': 'Malaysian Ringgit', 'symbol': 'RM'},
  {'code': 'THB', 'name': 'Thai Baht', 'symbol': '฿'},
  {'code': 'HKD', 'name': 'Hong Kong Dollar', 'symbol': 'HK\$'},
  {'code': 'NZD', 'name': 'New Zealand Dollar', 'symbol': 'NZ\$'},
  {'code': 'SEK', 'name': 'Swedish Krona', 'symbol': 'kr'},
  {'code': 'NOK', 'name': 'Norwegian Krone', 'symbol': 'kr'},
];

const List<Map<String, String>> kLanguages = [
  {'code': 'en', 'name': 'English'},
  {'code': 'ar', 'name': 'Arabic'},
  {'code': 'fr', 'name': 'French'},
  {'code': 'de', 'name': 'German'},
  {'code': 'es', 'name': 'Spanish'},
  {'code': 'it', 'name': 'Italian'},
  {'code': 'pt', 'name': 'Portuguese'},
  {'code': 'ru', 'name': 'Russian'},
  {'code': 'zh', 'name': 'Chinese'},
  {'code': 'ja', 'name': 'Japanese'},
  {'code': 'ko', 'name': 'Korean'},
  {'code': 'hi', 'name': 'Hindi'},
  {'code': 'tr', 'name': 'Turkish'},
  {'code': 'nl', 'name': 'Dutch'},
  {'code': 'sv', 'name': 'Swedish'},
  {'code': 'pl', 'name': 'Polish'},
  {'code': 'th', 'name': 'Thai'},
  {'code': 'id', 'name': 'Indonesian'},
  {'code': 'ms', 'name': 'Malay'},
  {'code': 'vi', 'name': 'Vietnamese'},
];

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    final favCount = ref.watch(favoritesProvider).length;
    final currency = ref.watch(selectedCurrencyProvider);
    final language = ref.watch(selectedLanguageProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ── Header ───────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).padding.top + 20, 20, 28),
              color: isDark ? AppColors.darkSurface : Colors.white,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.accent,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withOpacity(0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'A',
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => _showEditProfile(context, isDark),
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.accent,
                              border: Border.all(
                                  color: isDark
                                      ? AppColors.darkSurface
                                      : Colors.white,
                                  width: 2),
                            ),
                            child: const Icon(Icons.edit_rounded,
                                size: 12, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text('Alex Mercer',
                      style: AppTextStyles.h2(dark: isDark)),
                  const SizedBox(height: 4),
                  Text('alex.mercer@luxdrive.com',
                      style:
                          AppTextStyles.body(dark: isDark).copyWith(fontSize: 13)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _StatBox(label: 'Saved', value: '$favCount', isDark: isDark),
                      _Divider(isDark: isDark),
                      _StatBox(label: 'Test Drives', value: '3', isDark: isDark),
                      _Divider(isDark: isDark),
                      _StatBox(label: 'Reviews', value: '12', isDark: isDark),
                    ],
                  ),
                ],
              ),
            ),

            // ── Membership ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.accent,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.workspace_premium_rounded,
                        color: Colors.white, size: 28),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PLATINUM MEMBER',
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Exclusive benefits & priority service',
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Active',
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Preferences ──────────────────────────────────────────
            _SettingsSection(
              title: 'Preferences',
              isDark: isDark,
              children: [
                _SettingsTile(
                  icon: isDark
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  label: 'Dark Mode',
                  isDark: isDark,
                  trailing: Switch.adaptive(
                    value: isDark,
                    onChanged: (_) =>
                        ref.read(isDarkModeProvider.notifier).state = !isDark,
                    activeColor: AppColors.accent,
                  ),
                ),
                _SettingsTile(
                  icon: Icons.notifications_rounded,
                  label: 'Notifications',
                  isDark: isDark,
                  trailing: Switch.adaptive(
                    value: true,
                    onChanged: (_) {},
                    activeColor: AppColors.accent,
                  ),
                ),
                _SettingsTile(
                  icon: Icons.currency_exchange_rounded,
                  label: 'Currency',
                  isDark: isDark,
                  value: currency,
                  showArrow: true,
                  onTap: () => _showCurrencyPicker(context, ref, isDark),
                ),
                _SettingsTile(
                  icon: Icons.language_rounded,
                  label: 'Language',
                  isDark: isDark,
                  value: language,
                  showArrow: true,
                  onTap: () => _showLanguagePicker(context, ref, isDark),
                ),
              ],
            ),

            // ── Account ───────────────────────────────────────────────
            _SettingsSection(
              title: 'Account',
              isDark: isDark,
              children: [
                _SettingsTile(
                  icon: Icons.person_rounded,
                  label: 'Edit Profile',
                  isDark: isDark,
                  showArrow: true,
                  onTap: () => _showEditProfile(context, isDark),
                ),
                _SettingsTile(
                  icon: Icons.lock_rounded,
                  label: 'Privacy & Security',
                  isDark: isDark,
                  showArrow: true,
                  onTap: () => _showPrivacy(context, isDark),
                ),
                _SettingsTile(
                  icon: Icons.credit_card_rounded,
                  label: 'Payment Methods',
                  isDark: isDark,
                  showArrow: true,
                  onTap: () => _showPayments(context, isDark),
                ),
                _SettingsTile(
                  icon: Icons.history_rounded,
                  label: 'Order History',
                  isDark: isDark,
                  showArrow: true,
                  onTap: () => _showOrderHistory(context, isDark),
                ),
              ],
            ),

            // ── Support ───────────────────────────────────────────────
            _SettingsSection(
              title: 'Support',
              isDark: isDark,
              children: [
                _SettingsTile(
                  icon: Icons.help_rounded,
                  label: 'Help Center',
                  isDark: isDark,
                  showArrow: true,
                  onTap: () => _showHelpCenter(context, isDark),
                ),
                _SettingsTile(
                  icon: Icons.star_rounded,
                  label: 'Rate the App',
                  isDark: isDark,
                  showArrow: true,
                  onTap: () => _showRateApp(context, isDark),
                ),
                _SettingsTile(
                  icon: Icons.info_rounded,
                  label: 'About LuxDrive',
                  isDark: isDark,
                  showArrow: true,
                  value: 'v2.0.0',
                  onTap: () => _showAbout(context, isDark),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: BorderSide(
                        color: AppColors.error.withOpacity(0.4), width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text(
                    'Sign Out',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
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

  // ── Sheets ────────────────────────────────────────────────────────────────
  void _showCurrencyPicker(
      BuildContext context, WidgetRef ref, bool isDark) {
    final current = ref.read(selectedCurrencyProvider);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _PickerSheet(
        title: 'Select Currency',
        isDark: isDark,
        items: kCurrencies
            .map((c) => _PickerItem(
                  value: c['code']!,
                  label: '${c['name']} (${c['symbol']})',
                  subtitle: c['code'],
                ))
            .toList(),
        selected: current,
        onSelect: (v) =>
            ref.read(selectedCurrencyProvider.notifier).state = v,
      ),
    );
  }

  void _showLanguagePicker(
      BuildContext context, WidgetRef ref, bool isDark) {
    final current = ref.read(selectedLanguageProvider);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _PickerSheet(
        title: 'Select Language',
        isDark: isDark,
        items: kLanguages
            .map((l) => _PickerItem(value: l['name']!, label: l['name']!))
            .toList(),
        selected: current,
        onSelect: (v) =>
            ref.read(selectedLanguageProvider.notifier).state = v,
      ),
    );
  }

  void _showEditProfile(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _EditProfileSheet(isDark: isDark),
    );
  }

  void _showPrivacy(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _InfoSheet(
        title: 'Privacy & Security',
        isDark: isDark,
        items: const [
          _InfoItem(
              icon: Icons.fingerprint_rounded,
              title: 'Biometric Login',
              subtitle: 'Use fingerprint or face to sign in'),
          _InfoItem(
              icon: Icons.lock_outline_rounded,
              title: 'Two-Factor Auth',
              subtitle: 'Extra layer of security for your account'),
          _InfoItem(
              icon: Icons.visibility_off_rounded,
              title: 'Data Privacy',
              subtitle: 'Control what data we collect'),
          _InfoItem(
              icon: Icons.delete_outline_rounded,
              title: 'Delete Account',
              subtitle: 'Permanently remove your account and data'),
        ],
      ),
    );
  }

  void _showPayments(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _PaymentsSheet(isDark: isDark),
    );
  }

  void _showOrderHistory(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _OrderHistorySheet(isDark: isDark),
    );
  }

  void _showHelpCenter(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _InfoSheet(
        title: 'Help Center',
        isDark: isDark,
        items: const [
          _InfoItem(
              icon: Icons.chat_bubble_outline_rounded,
              title: 'Live Chat',
              subtitle: 'Chat with our support team 24/7'),
          _InfoItem(
              icon: Icons.phone_rounded,
              title: 'Call Support',
              subtitle: '+1 (800) LUX-DRIVE'),
          _InfoItem(
              icon: Icons.email_outlined,
              title: 'Email Us',
              subtitle: 'support@luxdrive.com'),
          _InfoItem(
              icon: Icons.help_outline_rounded,
              title: 'FAQs',
              subtitle: 'Find answers to common questions'),
          _InfoItem(
              icon: Icons.book_outlined,
              title: 'User Guide',
              subtitle: 'Learn how to use LuxDrive'),
        ],
      ),
    );
  }

  void _showRateApp(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _RateAppSheet(isDark: isDark),
    );
  }

  void _showAbout(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _AboutSheet(isDark: isDark),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────
class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  const _StatBox({required this.label, required this.value, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: AppTextStyles.h2(dark: isDark)
                .copyWith(color: AppColors.accent, fontSize: 24)),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.caption(dark: isDark)),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  final bool isDark;
  const _Divider({required this.isDark});
  @override
  Widget build(BuildContext context) => Container(
        width: 1,
        height: 36,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        color: isDark ? AppColors.darkCardElevated : Colors.black12,
      );
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool isDark;
  const _SettingsSection(
      {required this.title, required this.children, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(),
              style: AppTextStyles.label(dark: isDark)
                  .copyWith(color: AppColors.accent, fontSize: 10, letterSpacing: 1.5)),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: isDark ? AppColors.darkCard : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: children.asMap().entries.map((e) {
                final last = e.key == children.length - 1;
                return Column(children: [
                  e.value,
                  if (!last)
                    Divider(
                      height: 1,
                      indent: 52,
                      color: isDark
                          ? AppColors.darkCardElevated
                          : Colors.black.withOpacity(0.04),
                    ),
                ]);
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
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.isDark,
    this.value,
    this.trailing,
    this.showArrow = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withOpacity(0.1),
              ),
              child: Icon(icon, size: 15, color: AppColors.accent),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  style: AppTextStyles.bodyMedium(dark: isDark)
                      .copyWith(fontSize: 14)),
            ),
            if (trailing != null) trailing!,
            if (value != null)
              Text(value!,
                  style: AppTextStyles.caption(dark: isDark)
                      .copyWith(fontSize: 13)),
            if (showArrow) ...[
              const SizedBox(width: 4),
              Icon(Icons.chevron_right_rounded,
                  size: 18,
                  color: isDark
                      ? AppColors.textTertiaryDark
                      : AppColors.textTertiaryLight),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Picker Sheet ─────────────────────────────────────────────────────────────
class _PickerItem {
  final String value;
  final String label;
  final String? subtitle;
  const _PickerItem({required this.value, required this.label, this.subtitle});
}

class _PickerSheet extends StatefulWidget {
  final String title;
  final bool isDark;
  final List<_PickerItem> items;
  final String selected;
  final ValueChanged<String> onSelect;

  const _PickerSheet({
    required this.title,
    required this.isDark,
    required this.items,
    required this.selected,
    required this.onSelect,
  });

  @override
  State<_PickerSheet> createState() => _PickerSheetState();
}

class _PickerSheetState extends State<_PickerSheet> {
  late String _selected;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.items
        .where((i) =>
            i.label.toLowerCase().contains(_search.toLowerCase()) ||
            (i.subtitle?.toLowerCase().contains(_search.toLowerCase()) ??
                false))
        .toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: EdgeInsets.fromLTRB(
          20, 8, 20, MediaQuery.of(context).padding.bottom + 20),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: widget.isDark
                  ? AppColors.textTertiaryDark
                  : Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(widget.title,
              style: AppTextStyles.h3(dark: widget.isDark)),
          const SizedBox(height: 12),
          TextField(
            onChanged: (v) => setState(() => _search = v),
            style: AppTextStyles.bodyMedium(dark: widget.isDark),
            decoration: InputDecoration(
              hintText: 'Search…',
              hintStyle: AppTextStyles.body(dark: widget.isDark),
              prefixIcon: Icon(Icons.search_rounded,
                  color: widget.isDark
                      ? AppColors.textTertiaryDark
                      : AppColors.textTertiaryLight,
                  size: 18),
              filled: true,
              fillColor: widget.isDark
                  ? AppColors.darkCard
                  : AppColors.lightBg,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final item = filtered[i];
                final isSelected = item.value == _selected;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selected = item.value);
                    widget.onSelect(item.value);
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected
                          ? AppColors.accent.withOpacity(0.1)
                          : Colors.transparent,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.label,
                                  style: AppTextStyles.bodyMedium(
                                      dark: widget.isDark,
                                      color: isSelected
                                          ? AppColors.accent
                                          : null)),
                              if (item.subtitle != null)
                                Text(item.subtitle!,
                                    style: AppTextStyles.caption(
                                        dark: widget.isDark)),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle_rounded,
                              color: AppColors.accent, size: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Edit Profile Sheet ────────────────────────────────────────────────────────
class _EditProfileSheet extends StatefulWidget {
  final bool isDark;
  const _EditProfileSheet({required this.isDark});

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  final _nameCtrl = TextEditingController(text: 'Alex Mercer');
  final _emailCtrl =
      TextEditingController(text: 'alex.mercer@luxdrive.com');
  final _phoneCtrl = TextEditingController(text: '+1 (555) 000-0000');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: EdgeInsets.fromLTRB(
            20, 8, 20, MediaQuery.of(context).padding.bottom + 20),
        decoration: BoxDecoration(
          color: widget.isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SheetHandle(isDark: widget.isDark),
            Text('Edit Profile',
                style: AppTextStyles.h3(dark: widget.isDark)),
            const SizedBox(height: 20),
            _Field(label: 'Full Name', ctrl: _nameCtrl, isDark: widget.isDark),
            const SizedBox(height: 12),
            _Field(
                label: 'Email',
                ctrl: _emailCtrl,
                isDark: widget.isDark,
                type: TextInputType.emailAddress),
            const SizedBox(height: 12),
            _Field(
                label: 'Phone',
                ctrl: _phoneCtrl,
                isDark: widget.isDark,
                type: TextInputType.phone),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Profile updated successfully'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppColors.success,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  final bool isDark;
  final TextInputType type;

  const _Field({
    required this.label,
    required this.ctrl,
    required this.isDark,
    this.type = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.caption(dark: isDark)
                .copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          keyboardType: type,
          style: AppTextStyles.bodyMedium(dark: isDark),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? AppColors.darkCard : AppColors.lightBg,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}

// ── Payments Sheet ────────────────────────────────────────────────────────────
class _PaymentsSheet extends StatelessWidget {
  final bool isDark;
  const _PaymentsSheet({required this.isDark});

  @override
  Widget build(BuildContext context) {
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
          _SheetHandle(isDark: isDark),
          Text('Payment Methods',
              style: AppTextStyles.h3(dark: isDark)),
          const SizedBox(height: 20),
          _PaymentCard(
              brand: 'Visa',
              last4: '4242',
              expiry: '12/26',
              isDark: isDark,
              isDefault: true),
          const SizedBox(height: 10),
          _PaymentCard(
              brand: 'Mastercard',
              last4: '8765',
              expiry: '09/25',
              isDark: isDark,
              isDefault: false),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Payment Method'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.accent,
                side: BorderSide(
                    color: AppColors.accent.withOpacity(0.4), width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  final String brand;
  final String last4;
  final String expiry;
  final bool isDark;
  final bool isDefault;

  const _PaymentCard({
    required this.brand,
    required this.last4,
    required this.expiry,
    required this.isDark,
    required this.isDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: isDark ? AppColors.darkCard : AppColors.lightBg,
        border: isDefault
            ? Border.all(color: AppColors.accent.withOpacity(0.4), width: 1.5)
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: AppColors.accent.withOpacity(0.1),
            ),
            child: Icon(Icons.credit_card_rounded,
                color: AppColors.accent, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$brand •••• $last4',
                    style: AppTextStyles.bodyMedium(dark: isDark)
                        .copyWith(fontSize: 14)),
                Text('Expires $expiry',
                    style: AppTextStyles.caption(dark: isDark)),
              ],
            ),
          ),
          if (isDefault)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text('Default',
                  style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accent)),
            ),
        ],
      ),
    );
  }
}

// ── Order History Sheet ───────────────────────────────────────────────────────
class _OrderHistorySheet extends StatelessWidget {
  final bool isDark;
  const _OrderHistorySheet({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final orders = [
      {'car': 'Tesla Model S Plaid', 'date': 'Apr 12, 2026', 'status': 'Delivered', 'price': '\$129,990'},
      {'car': 'BMW M4 Competition', 'date': 'Feb 3, 2026', 'status': 'Delivered', 'price': '\$89,900'},
      {'car': 'Porsche Taycan Turbo S', 'date': 'Nov 18, 2025', 'status': 'Cancelled', 'price': '\$187,650'},
    ];

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: EdgeInsets.fromLTRB(
          20, 8, 20, MediaQuery.of(context).padding.bottom + 20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          _SheetHandle(isDark: isDark),
          Text('Order History', style: AppTextStyles.h3(dark: isDark)),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final o = orders[i];
                final delivered = o['status'] == 'Delivered';
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
                          color: (delivered ? AppColors.success : AppColors.error)
                              .withOpacity(0.1),
                        ),
                        child: Icon(
                          delivered
                              ? Icons.check_circle_rounded
                              : Icons.cancel_rounded,
                          color: delivered ? AppColors.success : AppColors.error,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(o['car']!,
                                style: AppTextStyles.bodyMedium(dark: isDark)
                                    .copyWith(fontSize: 13),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            Text(o['date']!,
                                style: AppTextStyles.caption(dark: isDark)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(o['price']!,
                              style: AppTextStyles.bodyMedium(dark: isDark)
                                  .copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700)),
                          Text(o['status']!,
                              style: TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 11,
                                  color: delivered
                                      ? AppColors.success
                                      : AppColors.error,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Rate App Sheet ────────────────────────────────────────────────────────────
class _RateAppSheet extends StatefulWidget {
  final bool isDark;
  const _RateAppSheet({required this.isDark});

  @override
  State<_RateAppSheet> createState() => _RateAppSheetState();
}

class _RateAppSheetState extends State<_RateAppSheet> {
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 8, 20, MediaQuery.of(context).padding.bottom + 24),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SheetHandle(isDark: widget.isDark),
          Text('Rate LuxDrive', style: AppTextStyles.h3(dark: widget.isDark)),
          const SizedBox(height: 8),
          Text('Your feedback helps us improve',
              style: AppTextStyles.body(dark: widget.isDark)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              return GestureDetector(
                onTap: () => setState(() => _rating = i + 1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    i < _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: AppColors.warning,
                    size: 40,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _rating > 0
                  ? () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Thank you for your $_rating-star rating!'),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: AppColors.success,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    }
                  : null,
              child: const Text('Submit Rating'),
            ),
          ),
        ],
      ),
    );
  }
}

// ── About Sheet ───────────────────────────────────────────────────────────────
class _AboutSheet extends StatelessWidget {
  final bool isDark;
  const _AboutSheet({required this.isDark});

  @override
  Widget build(BuildContext context) {
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
          _SheetHandle(isDark: isDark),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: AppColors.accent),
            child: const Center(
              child: Text('L',
                  style: TextStyle(
                      fontFamily: 'Urbanist',
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 28)),
            ),
          ),
          const SizedBox(height: 12),
          Text('LuxDrive', style: AppTextStyles.h2(dark: isDark)),
          const SizedBox(height: 4),
          Text('Version 2.0.0',
              style: AppTextStyles.body(dark: isDark).copyWith(fontSize: 13)),
          const SizedBox(height: 16),
          Text(
            'LuxDrive is your premium gateway to the world\'s finest automobiles. Browse, explore, and experience luxury cars like never before.',
            style: AppTextStyles.body(dark: isDark),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text('© 2026 LuxDrive. All rights reserved.',
              style: AppTextStyles.caption(dark: isDark)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ── Info Sheet ────────────────────────────────────────────────────────────────
class _InfoItem {
  final IconData icon;
  final String title;
  final String subtitle;
  const _InfoItem(
      {required this.icon, required this.title, required this.subtitle});
}

class _InfoSheet extends StatelessWidget {
  final String title;
  final bool isDark;
  final List<_InfoItem> items;

  const _InfoSheet(
      {required this.title, required this.isDark, required this.items});

  @override
  Widget build(BuildContext context) {
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
          _SheetHandle(isDark: isDark),
          Text(title, style: AppTextStyles.h3(dark: isDark)),
          const SizedBox(height: 16),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accent.withOpacity(0.1),
                    ),
                    child: Icon(item.icon, color: AppColors.accent, size: 18),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title,
                          style: AppTextStyles.bodyMedium(dark: isDark)
                              .copyWith(fontSize: 14)),
                      Text(item.subtitle,
                          style: AppTextStyles.caption(dark: isDark)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  final bool isDark;
  const _SheetHandle({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 4,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.textTertiaryDark : Colors.black12,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
