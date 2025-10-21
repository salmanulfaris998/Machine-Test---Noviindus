class Category {
  const Category({
    required this.id,
    required this.title,
    required this.image,
  });

  final int id;
  final String title;
  final String image;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );
  }
}

class CategoryListResponse {
  const CategoryListResponse({required this.categories});

  final List<Category> categories;

  factory CategoryListResponse.fromJson(Map<String, dynamic> json) {
    final list = json['categories'] as List<dynamic>? ?? [];
    return CategoryListResponse(
      categories: list
          .map((item) => Category.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
