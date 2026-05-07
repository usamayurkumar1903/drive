// lib/presentation/screens/home/widgets/search_bar_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/providers/car_provider.dart';

class SearchBarWidget extends ConsumerStatefulWidget {
  const SearchBarWidget({super.key});

  @override
  ConsumerState<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends ConsumerState<SearchBarWidget> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkModeProvider);
    final query = ref.watch(searchQueryProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: isDark ? AppColors.darkCard : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: _focusNode.hasFocus
                        ? AppColors.accent.withOpacity(0.2)
                        : Colors.black.withOpacity(isDark ? 0.25 : 0.06),
                    blurRadius: _focusNode.hasFocus ? 16 : 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: _focusNode.hasFocus
                      ? AppColors.accent.withOpacity(0.5)
                      : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                onChanged: (v) {
                  ref.read(searchQueryProvider.notifier).state = v;
                  ref.read(isSearchActiveProvider.notifier).state =
                      v.isNotEmpty;
                },
                style: AppTextStyles.bodyMedium(dark: isDark),
                decoration: InputDecoration(
                  hintText: 'Search brand, model, category…',
                  hintStyle: AppTextStyles.body(dark: isDark),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: isDark
                        ? AppColors.textTertiaryDark
                        : AppColors.textSecondaryLight.withOpacity(0.5),
                    size: 20,
                  ),
                  suffixIcon: query.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            _controller.clear();
                            ref.read(searchQueryProvider.notifier).state = '';
                            ref
                                .read(isSearchActiveProvider.notifier)
                                .state = false;
                            _focusNode.unfocus();
                          },
                          child: Icon(
                            Icons.cancel_rounded,
                            color: isDark
                                ? AppColors.textTertiaryDark
                                : AppColors.textSecondaryLight,
                            size: 18,
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
