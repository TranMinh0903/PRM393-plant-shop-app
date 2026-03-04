import 'dart:convert';
import 'api_client.dart';
import '../models/category.dart';

/// Service xử lý categories với BE Tree API
class CategoryService {
  CategoryService._();

  /// Lấy danh sách danh mục - GET /categories
  static Future<List<Category>> getCategories({
    int pageIndex = 1,
    int pageSize = 50,
  }) async {
    try {
      final queryParams = <String, String>{
        'pageIndex': pageIndex.toString(),
        'pageSize': pageSize.toString(),
      };

      final response =
          await ApiClient.get('/categories', queryParams: queryParams);
      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['isSuccess'] == true) {
        final data = body['data'];
        final items = data['items'] as List? ?? [];
        return items.map((item) => Category.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
