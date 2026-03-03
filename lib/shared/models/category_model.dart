/// Model danh mục - khớp với CategoryResponse của BE Tree API
class CategoryModel {
  final int id;
  final String categoryName;
  final String? description;
  final bool? status;

  CategoryModel({
    required this.id,
    required this.categoryName,
    this.description,
    this.status,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      categoryName: json['categoryName'] ?? '',
      description: json['description'],
      status: json['status'],
    );
  }
}
