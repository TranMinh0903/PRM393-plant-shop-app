# Ứng dụng Quản lý & Kinh doanh Cây cảnh (Plant Shop App)



## Mục lục

1. [Yêu cầu hệ thống](#yêu-cầu-hệ-thống)
2. [Clone dự án](#clone-dự-án)
3. [Cài đặt & Setup](#cài-đặt--setup)
4. [Chạy ứng dụng](#chạy-ứng-dụng)
5. [API Integration - Cách gọi API](#api-integration---cách-gọi-api)
6. [Cấu trúc thư mục](#cấu-trúc-thư-mục)
7. [Công nghệ sử dụng](#công-nghệ-sử-dụng)
8. [Sự cố thường gặp](#sự-cố-thường-gặp)

---

##  Yêu cầu hệ thống

Trước khi bắt đầu, hãy đảm bảo bạn có:

- **Flutter SDK:** Version 3.10.7 trở lên
  - [Tải Flutter tại đây](https://flutter.dev/docs/get-started/install)
- **Dart SDK:** Đi kèm với Flutter
- **Android Studio** hoặc **VS Code** + Flutter Extension
- **Git:** Để clone repository
- **Emulator/Device:** Android hoặc iOS device để chạy ứng dụng
- **Backend Server:** Chạy ở `http://localhost:9090` (hoặc địa chỉ IP khác),
- [Backend GIT](https://github.com/TranMinh0903/TreeShop)

### Kiểm tra cài đặt Flutter

```bash
flutter doctor
```

Đây sẽ hiển thị trạng thái của các công cụ cần thiết. Tất cả mục cần có ✓

---

##  Clone dự án

### Cách 1: Clone từ GitHub

```bash
git clone https://github.com/your-organization/PRM393-plant-shop-app.git
cd PRM393-plant-shop-app
```

### Cách 2: Clone từ GitLab hoặc Repository khác

```bash
git clone https://your-git-server/PRM393-plant-shop-app.git
cd PRM393-plant-shop-app
```

---

## ⚙️ Cài đặt & Setup

### Bước 1: Cài đặt Dependencies

Chạy lệnh sau để tải tất cả dependencies của project:

```bash
flutter pub get
```

Hoặc nếu cần cài lại toàn bộ:

```bash
flutter clean
flutter pub get
```

### Bước 2: Build Dependency Injection (Injectable)

Dự án sử dụng `get_it` và `injectable` để quản lý dependencies tự động. Cần build file không:

```bash
flutter pub run build_runner build
```

Nếu cần clean trước đó:

```bash
flutter pub run build_runner clean
flutter pub run build_runner build
```

### Bước 3: Cấu hình API Endpoint

File cấu hình API nằm tại: `lib/core/config/api_config.dart`

**Cho Android Emulator (mặc định):**

```dart
static const String baseUrl = 'http://10.0.2.2:9090/api/v1';
```

**Cho thiết bị thật (Phone/Tablet) - thay IP máy tính:**

```dart
static const String baseUrl = 'http://192.168.1.100:9090/api/v1';
```

**Cho Web:**

```dart
static const String baseUrl = 'http://localhost:9090/api/v1';
```

> **Lưu ý:** Hãy tìm IP máy tính của bạn bằng `ipconfig` (Windows) hoặc `ifconfig` (Mac/Linux)

### Bước 4: Cấu hình Cloudinary (Nếu cần upload ảnh)

File cấu hình nằm tại: `lib/core/config/api_config.dart`

```dart
class CloudinaryConfig {
  static const String cloudName = 'your-cloud-name';
  static const String uploadPreset = 'your-upload-preset';
}
```

---

## Chạy ứng dụng

### Chạy trên Android Emulator

```bash
# Liệt kê các emulator available
flutter emulators

# Khởi động một emulator
flutter emulators --launch emulator_name

# Chạy ứng dụng
flutter run
```

### Chạy trên thiết bị iPhone/Android thực

```bash
# Kết nối thiết bị qua USB, sau đó:
flutter run
```

### Chạy trên Web

```bash
flutter run -d chrome
```

### Chạy với debug flag

```bash
flutter run --debug
```

### Chạy release build (tối ưu hóa)

```bash
flutter run --release
```

### Tắt debug banner

Ứng dụng đã tắt debug banner mặc định trong `lib/app.dart`:

```dart
debugShowCheckedModeBanner: false,
```

---

## API Integration - Cách gọi API

Dự án sử dụng `ApiClient` - một wrapper cho `http` package để gọi API một cách dễ dàng.

### Vị trí file API Client

- **API Client:** `lib/core/network/api_client.dart`
- **API Config:** `lib/core/config/api_config.dart`
- **Auth Storage:** `lib/core/services/auth_storage.dart`

### Tính năng của ApiClient

-  Tự động thêm JWT Token vào Headers (nếu có)
-  Hỗ trợ GET, POST, PUT, DELETE requests
-  Support query parameters cho GET requests
-  JSON encoding/decoding tự động
-  Base URL được cấu hình tập trung

### Cách sử dụng ApiClient

#### 1. **GET Request** - Lấy danh sách cây cảnh

```dart
import 'package:plant_shop_app/core/network/api_client.dart';

// Lấy danh sách sản phẩm
final response = await ApiClient.get('/products');

if (response.statusCode == 200) {
  final List<dynamic> products = jsonDecode(response.body)['data'];
  print('Products: $products');
} else {
  print('Error: ${response.statusCode}');
}
```

#### 2. **GET Request với Query Parameters**

```dart
// Lấy danh sách sản phẩm với phân trang và tìm kiếm
final response = await ApiClient.get(
  '/products',
  queryParams: {
    'page': '1',
    'limit': '10',
    'search': 'Hoa hồng',
  },
);

final data = jsonDecode(response.body);
print('Total: ${data['pagination']['total']}');
print('Products: ${data['data']}');
```

#### 3. **POST Request** - Tạo đơn hàng mới

```dart
final orderData = {
  'products': [
    {'id': '1', 'quantity': 2},
    {'id': '3', 'quantity': 1},
  ],
  'shippingAddress': '123 Nguyễn Huệ, TPHCM',
  'notes': 'Giao hàng buổi sáng',
};

final response = await ApiClient.post('/orders', orderData);

if (response.statusCode == 201) {
  final order = jsonDecode(response.body);
  print('Order created: ${order['id']}');
} else {
  print('Error: ${response.statusCode}');
}
```

#### 4. **PUT Request** - Cập nhật thông tin cá nhân

```dart
final updateData = {
  'fullName': 'Nguyễn Văn A',
  'phone': '0123456789',
  'address': '456 Lê Lợi, Hà Nội',
};

final response = await ApiClient.put('/users/profile', updateData);

if (response.statusCode == 200) {
  print('Profile updated successfully');
}
```

#### 5. **DELETE Request** - Xóa sản phẩm khỏi giỏ hàng

```dart
final response = await ApiClient.delete('/cart/items/product-id-123');

if (response.statusCode == 200) {
  print('Item removed from cart');
}
```

### Xác thực JWT Token

ApiClient **tự động thêm JWT Token** vào mọi request nếu token đã được lưu:

```dart
// Sau khi login thành công, lưu token
AuthStorage.token = 'eyJhbGciOiJIUzI1NiIs...';

// Token sẽ được tự động thêm vào headers của mọi request
// Headers: { 'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIs...' }

// Khi logout, xóa token
AuthStorage.token = null;
```

**File liên quan:** `lib/core/services/auth_storage.dart`

### Sử dụng ApiClient trong BLoC

Dự án sử dụng **BLoC Pattern** để quản lý state. Dưới đây là cách tích hợp ApiClient trong BLoC:

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_shop_app/core/network/api_client.dart';
import 'dart:convert';

// Events
abstract class ProductEvent {}

class FetchProductsEvent extends ProductEvent {
  final int page;
  FetchProductsEvent({this.page = 1});
}

// States
abstract class ProductState {}

class ProductLoadingState extends ProductState {}

class ProductLoadedState extends ProductState {
  final List<Product> products;
  ProductLoadedState(this.products);
}

class ProductErrorState extends ProductState {
  final String message;
  ProductErrorState(this.message);
}

// BLoC
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductLoadingState()) {
    on<FetchProductsEvent>((event, emit) async {
      emit(ProductLoadingState());
      try {
        final response = await ApiClient.get(
          '/products',
          queryParams: {'page': event.page.toString()},
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final products = (data['data'] as List)
              .map((p) => Product.fromJson(p))
              .toList();
          emit(ProductLoadedState(products));
        } else {
          emit(ProductErrorState('Failed to load products'));
        }
      } catch (e) {
        emit(ProductErrorState(e.toString()));
      }
    });
  }
}
```

### 🛠️ Helper Function - Xử lý Response

```dart
import 'dart:convert';
import 'package:plant_shop_app/core/network/api_client.dart';

// Helper để handle response một cách dễ dàng
Future<T?> apiCall<T>({
  required Future<http.Response> Function() request,
  required T Function(dynamic json) fromJson,
}) async {
  try {
    final response = await request();

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return fromJson(data['data'] ?? data);
    } else if (response.statusCode == 401) {
      // Token expired - redirect to login
      print('Unauthorized - Token expired');
      return null;
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Exception: $e');
    return null;
  }
}

// Cách sử dụng
final product = await apiCall<Product>(
  request: () => ApiClient.get('/products/123'),
  fromJson: (json) => Product.fromJson(json),
);
```

---

##  Cấu trúc thư mục

```
lib/
├── main.dart                 # Entry point của ứng dụng
├── app.dart                  # Root widget
├── core/                     # Core functionality
│   ├── config/
│   │   └── api_config.dart   # Cấu hình API & Cloudinary
│   ├── constants/            # Constants & enums
│   ├── network/
│   │   ├── api_client.dart   # HTTP client wrapper
│   │   └── auth_storage.dart # JWT Token storage
│   ├── routes/
│   │   └── app_routes.dart   # Navigation routes (go_router)
│   ├── services/             # Business logic services
│   ├── theme/
│   │   └── app_theme.dart    # Material theme
│   └── dependency_injection/ # GetIt & Injectable setup
├── features/                 # Feature modules (BLoC architecture)
│   ├── auth/                 # Authentication feature
│   │   ├── bloc/
│   │   ├── pages/
│   │   ├── widgets/
│   │   └── models/
│   ├── home/                 # Home screen
│   │   ├── bloc/
│   │   ├── pages/
│   │   └── widgets/
│   └── product/              # Product management
│       ├── bloc/
│       ├── pages/
│       ├── widgets/
│       └── models/
└── shared/                   # Shared utilities
    ├── models/               # Common data models
    └── widgets/              # Reusable widgets
```

