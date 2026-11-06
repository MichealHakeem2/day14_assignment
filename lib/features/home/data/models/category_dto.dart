import 'package:shopping_app/features/home/domain/entities/category_entity.dart';

class CategoryDto {
  final String name;
  final String slug;

  CategoryDto({
    required this.name,
    required this.slug,
  });

  // fromJson
  factory CategoryDto.fromJson(dynamic json) {
    if (json is String) {
      return CategoryDto(name: json, slug: json);
    }
    if (json is Map<String, dynamic>) {
      final nameVal = json['name']?.toString() ?? json['slug']?.toString() ?? '';
      final slugVal = json['slug']?.toString() ?? json['name']?.toString() ?? '';
      return CategoryDto(
        name: nameVal,
        slug: slugVal,
      );
    }
    final str = json?.toString() ?? '';
    return CategoryDto(name: str, slug: str);
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
    };
  }

  // convert DTO to Entity
  CategoryEntity toEntity() {
    return CategoryEntity(
      name: name,
      slug: slug,
    );
  }
}

