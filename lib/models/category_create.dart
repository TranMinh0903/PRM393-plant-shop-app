/// DTO tạo/cập nhật danh mục mới - gửi lên BE Tree API
class CategoryCreate {
  final String categoryName;
  final String? description;

  CategoryCreate({required this.categoryName, this.description});

  Map<String, dynamic> toJson() {
    return {'categoryName': categoryName, 'description': description};
  }
}
