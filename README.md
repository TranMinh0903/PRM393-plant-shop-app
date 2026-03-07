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
git clone https://github.com/TranMinh0903/PRM393-plant-shop-app.git
cd PRM393-plant-shop-app
```

### Cách 2: Clone từ GitLab hoặc Repository khác

```bash
git clone https://github.com/TranMinh0903/PRM393-plant-shop-app.git
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

File cấu hình API nằm tại: `lib/services/api_config.dart`

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

File cấu hình nằm tại: `lib/services/api_config.dart`

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

- **API Client:** `lib/services/api_client.dart`
- **API Config:** `lib/services/api_config.dart`
- **Auth Storage:** `lib/services/auth_storage.dart`

### Tính năng của ApiClient

-  Tự động thêm JWT Token vào Headers (nếu có)
-  Hỗ trợ GET, POST, PUT, DELETE requests
-  Support query parameters cho GET requests
-  JSON encoding/decoding tự động
-  Base URL được cấu hình tập trung

### Cách sử dụng ApiClient

#### 1. **GET Request** - Lấy danh sách cây cảnh

```dart
import 'package:plant_shop_app/services/api_client.dart';

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

**File liên quan:** `lib/services/auth_storage.dart`

### Sử dụng ApiClient trong BLoC

Dự án sử dụng **BLoC Pattern** để quản lý state. Dưới đây là cách tích hợp ApiClient trong BLoC:

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_shop_app/services/api_client.dart';
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
import 'package:plant_shop_app/services/api_client.dart';

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
├── main.dart                          # Entry point của ứng dụng
├── app.dart                           # Root widget (ShadcnApp + Provider)
│
├── models/                            # Data models
│   ├── api_response.dart              # API response wrapper
│   ├── product.dart                   # Product model
│   ├── product_create.dart            # Product create DTO
│   ├── category.dart                  # Category model
│   └── category_create.dart           # Category create DTO
│
├── services/                          # API & services
│   ├── api_client.dart                # HTTP client wrapper
│   ├── api_config.dart                # API URL configuration
│   ├── app_constants.dart             # App constants
│   ├── app_routes.dart                # Navigation routes (go_router)
│   ├── auth_service.dart              # Login / Register / Logout
│   ├── auth_storage.dart              # JWT Token storage
│   ├── category_service.dart          # Category API service
│   └── db_helper.dart                 # Local database helper
│
├── repositories/                      # Data repositories
│   └── product_repo.dart              # Product API repository
│
├── viewmodels/                        # ViewModel layer (ChangeNotifier)
│   ├── admin_product_viewmodel.dart   # Admin product management
│   ├── product_create_state.dart      # Create product state
│   ├── product_create_viewmodel.dart  # Create product logic
│   ├── product_list_state.dart        # Product list state
│   └── product_list_viewmodel.dart    # Product list logic
│
├── views/                             # UI Screens
│   ├── admin_manage_screen.dart       # Admin management
│   ├── cart_screen.dart               # Shopping cart
│   ├── create_product_screen.dart     # Create product form
│   ├── login_screen.dart              # Login / Register
│   ├── product_details_screen.dart    # Product details
│   ├── product_screen.dart            # Product listing
│   └── shipper_deliveries_screen.dart # Shipper deliveries
│
└── widgets/                           # Reusable UI components
    └── main_shell.dart                # Main navigation shell
```

---

## EF Core - Kết nối Database (Backend)

Backend sử dụng **Entity Framework Core** với **SQL Server** để quản lý database.

### Cấu trúc Database (5 bảng chính)

| Bảng | Mô tả |
|------|-------|
| `Account` | Tài khoản người dùng (User/Admin/Shipper) |
| `Category` | Danh mục cây cảnh |
| `Product` | Sản phẩm cây cảnh |
| `Order` | Đơn hàng |
| `OrderDetail` | Chi tiết đơn hàng |

### DbContext - Khai báo kết nối

File: `PRN232.TreeShop.Repo/Entities/ShopDBContext.cs`

```csharp
public partial class ShopDBContext : DbContext
{
    public ShopDBContext(DbContextOptions<ShopDBContext> options)
        : base(options) { }

    public virtual DbSet<Account> Accounts { get; set; }
    public virtual DbSet<Category> Categories { get; set; }
    public virtual DbSet<Product> Products { get; set; }
    public virtual DbSet<Order> Orders { get; set; }
    public virtual DbSet<OrderDetail> OrderDetails { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        // Fluent API configuration cho từng Entity
        modelBuilder.Entity<Product>(entity =>
        {
            entity.ToTable("Product");
            entity.Property(e => e.Price).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.ProductName).HasMaxLength(200);

            // Foreign Key - Product thuộc Category
            entity.HasOne(d => d.Category)
                .WithMany(p => p.Products)
                .HasForeignKey(d => d.CategoryId);
        });
    }
}
```

### Connection String

File: `appsettings.json`

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=sqlserver,1433;Database=ShopDB;User Id=sa;Password=TreeShop@123;TrustServerCertificate=True;Encrypt=False;"
  }
}
```

### Đăng ký EF Core trong Program.cs

```csharp
// Kết nối SQL Server qua EF Core
builder.Services.AddDbContext<ShopDBContext>(option =>
    option.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// Dependency Injection - Repository & Service
builder.Services.AddScoped<UnitOfWork>();
builder.Services.AddScoped<ProductRepo>();
builder.Services.AddScoped<CategoryRepo>();
builder.Services.AddScoped<OrderRepo>();
builder.Services.AddScoped<ProductService>();
builder.Services.AddScoped<CategoryService>();
builder.Services.AddScoped<OrderService>();
```

### Tài khoản mặc định (Seed Data)

Backend tự động tạo tài khoản mặc định khi khởi chạy:

| Username | Password | Role |
|----------|----------|------|
| `admin` | `admin123` | Admin |
| `shipper` | `shipper123` | Shipper |

---

## SQLite - Lưu dữ liệu Local (Flutter)

Ứng dụng hỗ trợ **SQLite** để lưu cache dữ liệu offline trên thiết bị.

### Bước 1: Cài đặt dependency

Thêm vào `pubspec.yaml`:

```yaml
dependencies:
  sqflite: ^2.3.0       # SQLite cho Flutter
  path: ^1.8.0          # Xử lý đường dẫn file
```

Sau đó chạy:

```bash
flutter pub get
```

### Bước 2: Cấu hình quyền truy cập

**Android** (`android/app/src/main/AndroidManifest.xml`):

SQLite **không cần cấu hình thêm** vì dữ liệu được lưu trong sandbox app (không cần quyền storage).

**iOS**: Cũng không cần cấu hình thêm.

### Bước 3: Tạo Database Helper

Tạo file `lib/services/db_helper.dart` để quản lý kết nối SQLite:

```dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Bước khởi tạo database
final db = await openDatabase(
  join(await getDatabasesPath(), 'plant_shop.db'),  // Đường dẫn file DB
  version: 1,                                        // Version để quản lý migration
  onCreate: (db, version) {
    // Tạo bảng khi lần đầu mở DB
    return db.execute('CREATE TABLE ...');
  },
);
```

> 💡 `getDatabasesPath()` trả về đường dẫn mặc định:
> - **Android**: `/data/data/<package>/databases/`
> - **iOS**: `Documents/`

### Bước 4: Tạo bảng và thao tác CRUD

### File: `lib/services/db_helper.dart`

```dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  DbHelper._();

  static Database? _database;

  /// Mở hoặc tạo database
  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await openDatabase(
      join(await getDatabasesPath(), 'plant_shop.db'),
      version: 1,
      onCreate: (db, version) async {
        // Tạo bảng cache sản phẩm
        await db.execute('''
          CREATE TABLE cached_products (
            id INTEGER PRIMARY KEY,
            productName TEXT NOT NULL,
            price REAL,
            imageUrl TEXT,
            categoryId INTEGER
          )
        ''');

        // Tạo bảng giỏ hàng local
        await db.execute('''
          CREATE TABLE cart_items (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            productId INTEGER NOT NULL,
            productName TEXT NOT NULL,
            price REAL NOT NULL,
            quantity INTEGER DEFAULT 1,
            imageUrl TEXT
          )
        ''');
      },
    );

    return _database!;
  }

  /// Lưu cache sản phẩm (khi offline)
  static Future<void> cacheProducts(List<Map<String, dynamic>> products) async {
    final db = await database;
    await db.delete('cached_products');
    for (final product in products) {
      await db.insert('cached_products', product);
    }
  }

  /// Lấy sản phẩm từ cache
  static Future<List<Map<String, dynamic>>> getCachedProducts() async {
    final db = await database;
    return db.query('cached_products');
  }

  /// Thêm sản phẩm vào giỏ hàng local
  static Future<void> addToCart(Map<String, dynamic> item) async {
    final db = await database;
    await db.insert('cart_items', item);
  }

  /// Lấy giỏ hàng local
  static Future<List<Map<String, dynamic>>> getCartItems() async {
    final db = await database;
    return db.query('cart_items');
  }

  /// Xóa giỏ hàng
  static Future<void> clearCart() async {
    final db = await database;
    await db.delete('cart_items');
  }
}
```

### Dependency cần thiết (`pubspec.yaml`)

```yaml
dependencies:
  sqflite: ^2.3.0
  path: ^1.8.0
```

> 💡 **Lưu ý:** SQLite dùng để lưu dữ liệu **offline/local** (cache, giỏ hàng). Dữ liệu chính vẫn lưu trên **SQL Server** thông qua API.
```
