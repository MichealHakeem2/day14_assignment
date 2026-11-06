import 'package:shopping_app/features/home/domain/entities/category_entity.dart';

class CategoryModel {
  final int? id;
  final String name;
  final String slug;
  final String? image;

  CategoryModel({
    this.id,
    required this.name,
    required this.slug,
    this.image,
  });

  factory CategoryModel.fromJson(dynamic json) {
    if (json is String) {
      return CategoryModel(name: json, slug: json);
    }
    if (json is Map<String, dynamic>) {
      final nameVal = json['name']?.toString() ?? json['slug']?.toString() ?? '';
      final slugVal = json['slug']?.toString() ?? json['name']?.toString() ?? '';
      return CategoryModel(
        id: json['id'] as int?,
        name: nameVal,
        slug: slugVal,
        image: json['image'] as String?,
      );
    }
    final str = json?.toString() ?? '';
    return CategoryModel(name: str, slug: str);
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as int?,
      name: map['name'] as String? ?? '',
      slug: map['slug'] as String? ?? map['name'] as String? ?? '',
      image: map['image'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'slug': slug,
      'image': image ?? '',
    };
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'slug': slug,
      if (image != null) 'image': image,
    };
  }

  CategoryEntity toEntity() {
    return CategoryEntity(name: name, slug: slug);
  }
}
