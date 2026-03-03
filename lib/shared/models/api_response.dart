/// Generic API response wrapper matching BE Tree's response format
class ApiResponse<T> {
  final bool isSuccess;
  final String? message;
  final T? data;

  ApiResponse({
    required this.isSuccess,
    this.message,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromData,
  ) {
    return ApiResponse(
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'],
      data: json['data'] != null && fromData != null
          ? fromData(json['data'])
          : null,
    );
  }
}
