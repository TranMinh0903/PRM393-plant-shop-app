/// Model danh mục - khớp với CategoryResponse của BE Tree API
class Category {
  final int id;
  final String categoryName;
  final String? description;
  final bool? status;

  Category({
    required this.id,
    required this.categoryName,
    this.description,
    this.status,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      categoryName: json['categoryName'] ?? '',
      description: json['description'],
      status: json['status'],
    );
  }
}
