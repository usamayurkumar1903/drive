// lib/data/providers/car_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/car_model.dart';
import '../repositories/car_repository.dart';

// ──────────────────────────────
// Repository
// ──────────────────────────────
final carRepositoryProvider = Provider<CarRepository>((_) => CarRepository());

// ──────────────────────────────
// Filter state
// ──────────────────────────────
class FilterState {
  final String? brand;
  final String? category;
  final double? minPrice;
  final double? maxPrice;
  final String? fuelType;
  final SortOption sortBy;

  const FilterState({
    this.brand,
    this.category,
    this.minPrice,
    this.maxPrice,
    this.fuelType,
    this.sortBy = SortOption.featured,
  });

  bool get hasActiveFilters =>
      brand != null ||
      category != null ||
      minPrice != null ||
      maxPrice != null ||
      fuelType != null ||
      sortBy != SortOption.featured;

  FilterState copyWith({
    String? brand,
    String? category,
    double? minPrice,
    double? maxPrice,
    String? fuelType,
    SortOption? sortBy,
    bool clearBrand = false,
    bool clearCategory = false,
    bool clearMinPrice = false,
    bool clearMaxPrice = false,
    bool clearFuelType = false,
  }) {
    return FilterState(
      brand: clearBrand ? null : brand ?? this.brand,
      category: clearCategory ? null : category ?? this.category,
      minPrice: clearMinPrice ? null : minPrice ?? this.minPrice,
      maxPrice: clearMaxPrice ? null : maxPrice ?? this.maxPrice,
      fuelType: clearFuelType ? null : fuelType ?? this.fuelType,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  FilterState reset() => const FilterState();
}

enum SortOption {
  featured('Featured'),
  priceAsc('Price: Low → High'),
  priceDesc('Price: High → Low'),
  nameAsc('Name A–Z'),
  newest('New Arrivals'),
  rating('Top Rated');

  const SortOption(this.label);
  final String label;
}

class FilterNotifier extends StateNotifier<FilterState> {
  FilterNotifier() : super(const FilterState());

  void setBrand(String? brand) => state = state.copyWith(
      brand: brand, clearBrand: brand == null);
  void setCategory(String? cat) => state = state.copyWith(
      category: cat, clearCategory: cat == null);
  void setMinPrice(double? v) => state = state.copyWith(
      minPrice: v, clearMinPrice: v == null);
  void setMaxPrice(double? v) => state = state.copyWith(
      maxPrice: v, clearMaxPrice: v == null);
  void setFuelType(String? v) => state = state.copyWith(
      fuelType: v, clearFuelType: v == null);
  void setSortBy(SortOption s) => state = state.copyWith(sortBy: s);
  void reset() => state = state.reset();
}

final filterProvider = StateNotifierProvider<FilterNotifier, FilterState>(
    (_) => FilterNotifier());

// ──────────────────────────────
// Cars list (filtered + sorted)
// ──────────────────────────────
final allCarsProvider = Provider<List<CarModel>>((ref) {
  return ref.watch(carRepositoryProvider).getAllCars();
});

final filteredCarsProvider = Provider<List<CarModel>>((ref) {
  final all = ref.watch(allCarsProvider);
  final filter = ref.watch(filterProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();

  var result = all.where((car) {
    if (query.isNotEmpty &&
        !car.name.toLowerCase().contains(query) &&
        !car.brand.toLowerCase().contains(query) &&
        !car.category.toLowerCase().contains(query)) return false;
    if (filter.brand != null && car.brand != filter.brand) return false;
    if (filter.category != null && car.category != filter.category) return false;
    if (filter.minPrice != null && car.price < filter.minPrice!) return false;
    if (filter.maxPrice != null && car.price > filter.maxPrice!) return false;
    if (filter.fuelType != null && car.specs.fuelType != filter.fuelType) {
      return false;
    }
    return true;
  }).toList();

  switch (filter.sortBy) {
    case SortOption.priceAsc:
      result.sort((a, b) => a.price.compareTo(b.price));
    case SortOption.priceDesc:
      result.sort((a, b) => b.price.compareTo(a.price));
    case SortOption.nameAsc:
      result.sort((a, b) => a.name.compareTo(b.name));
    case SortOption.newest:
      result = result.where((c) => c.isNew).toList() +
          result.where((c) => !c.isNew).toList();
    case SortOption.rating:
      result.sort((a, b) => b.rating.compareTo(a.rating));
    case SortOption.featured:
      result = result.where((c) => c.isFeatured).toList() +
          result.where((c) => !c.isFeatured).toList();
  }

  return result;
});

final featuredCarsProvider = Provider<List<CarModel>>((ref) {
  return ref.watch(carRepositoryProvider).getFeaturedCars();
});

final newArrivalCarsProvider = Provider<List<CarModel>>((ref) {
  return ref.watch(carRepositoryProvider).getNewArrivals();
});

// ──────────────────────────────
// Search
// ──────────────────────────────
final searchQueryProvider = StateProvider<String>((_) => '');

final isSearchActiveProvider = StateProvider<bool>((_) => false);

// ──────────────────────────────
// Favorites
// ──────────────────────────────
class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super({}) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('favorites') ?? [];
    state = Set.from(saved);
  }

  Future<void> toggle(String carId) async {
    final updated = Set<String>.from(state);
    if (updated.contains(carId)) {
      updated.remove(carId);
    } else {
      updated.add(carId);
    }
    state = updated;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', updated.toList());
  }

  bool isFavorite(String carId) => state.contains(carId);
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>(
        (_) => FavoritesNotifier());

final favoriteCarsProvider = Provider<List<CarModel>>((ref) {
  final favoriteIds = ref.watch(favoritesProvider);
  final all = ref.watch(allCarsProvider);
  return all.where((c) => favoriteIds.contains(c.id)).toList();
});

// ──────────────────────────────
// Theme
// ──────────────────────────────
final isDarkModeProvider = StateProvider<bool>((_) => true);

// ──────────────────────────────
// Nav index
// ──────────────────────────────
final navIndexProvider = StateProvider<int>((_) => 0);
