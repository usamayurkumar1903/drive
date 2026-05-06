// lib/data/models/car_model.dart

class CarModel {
  final String id;
  final String name;
  final String brand;
  final double price;
  final String imagePath;
  final List<String> galleryImages;
  final String description;
  final CarSpecs specs;
  final String category;
  final double rating;
  final int reviewCount;
  final bool isNew;
  final bool isFeatured;
  final List<String> colors;
  final String year;

  const CarModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.imagePath,
    required this.galleryImages,
    required this.description,
    required this.specs,
    required this.category,
    this.rating = 4.5,
    this.reviewCount = 128,
    this.isNew = false,
    this.isFeatured = false,
    required this.colors,
    required this.year,
  });

  CarModel copyWith({
    String? id,
    String? name,
    String? brand,
    double? price,
    String? imagePath,
    List<String>? galleryImages,
    String? description,
    CarSpecs? specs,
    String? category,
    double? rating,
    int? reviewCount,
    bool? isNew,
    bool? isFeatured,
    List<String>? colors,
    String? year,
  }) {
    return CarModel(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      galleryImages: galleryImages ?? this.galleryImages,
      description: description ?? this.description,
      specs: specs ?? this.specs,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isNew: isNew ?? this.isNew,
      isFeatured: isFeatured ?? this.isFeatured,
      colors: colors ?? this.colors,
      year: year ?? this.year,
    );
  }
}

class CarSpecs {
  final String engine;
  final String horsepower;
  final String torque;
  final String acceleration; // 0-100 km/h
  final String topSpeed;
  final String transmission;
  final String drivetrain;
  final String fuelType;
  final String fuelConsumption;
  final String seating;
  final String weight;
  final String range; // for EVs

  const CarSpecs({
    required this.engine,
    required this.horsepower,
    required this.torque,
    required this.acceleration,
    required this.topSpeed,
    required this.transmission,
    required this.drivetrain,
    required this.fuelType,
    this.fuelConsumption = 'N/A',
    required this.seating,
    required this.weight,
    this.range = 'N/A',
  });
}
