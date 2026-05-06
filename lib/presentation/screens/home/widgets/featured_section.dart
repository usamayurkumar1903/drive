// lib/presentation/screens/home/widgets/featured_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/providers/car_provider.dart';
import '../../../widgets/car_card/car_grid_card.dart';
import '../../detail/car_detail_screen.dart';

class FeaturedSection extends ConsumerWidget {
  const FeaturedSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featured = ref.watch(featuredCarsProvider);

    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
        itemCount: featured.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, i) {
          final car = featured[i];
          return FeaturedCarCard(
            car: car,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CarDetailScreen(car: car)),
            ),
          );
        },
      ),
    );
  }
}
