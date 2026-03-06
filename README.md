# Ứng dụng Quản lý & Kinh doanh Cây cảnh (Plant Shop App)


##  Yêu cầu hệ thống

Trước khi bắt đầu, hãy đảm bảo bạn có:
- Clone src code [Backend GIT](https://github.com/TranMinh0903/TreeShop)

### Kiểm tra cài đặt Flutter

```bash
flutter doctor
```

Đây sẽ hiển thị trạng thái của các công cụ cần thiết. Tất cả mục cần có ✓

---

##  Clone dự án

### Clone từ GitHub

```bash
git clone https://github.com/your-organization/PRM393-plant-shop-app.git
cd PRM393-plant-shop-app
```

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

### Bước 2: Cấu hình API Endpoint

File cấu hình API nằm tại: `lib/core/config/api_config.dart`

**Cho Android Emulator (mặc định):**

```dart
static const String baseUrl = 'http://10.0.2.2:9090/api/v1';
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

### Chạy trên thiết bị Android thực

```bash
# Kết nối thiết bị qua USB, sau đó:
flutter run
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

