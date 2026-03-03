import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../shared/models/product_model.dart';
import '../../../product/data/product_service.dart';

/// Product Detail Page - shows full plant info with hero image,
/// care stats, description, and add-to-cart bottom bar
class ProductDetailPage extends StatefulWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;
  bool _isFavorite = false;
  bool _isLoading = true;

  ProductModel? _product;

  // Ảnh minh họa vì API chưa có trường image
  final String _defaultImage =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDRgK_fIBMNXt0eUOTItxnJQGo3Lw55z36pcP0Zzwo5vsw77vVCwTPPbdWyA6ekcgn48QQmhA5su_tMsjm2C-jqd5XTWNX65fspQX0_DJC80u8BIEjgCFfRfVJbddifGb6rj7Cg99bJDFpYYWtD57vt7c2AdtFx0tt-6GN91tOaip4yvTN9wnQaT1YGfSZqNRzCsibznKzfFVo7_lq8VkB9Le8cM0aV6qJcHe2ImdQ9WZ0bZKMnkTDwqjP-yDKteyxZmH9uqRkxJHcc';

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  /// Load product detail từ BE Tree API
  Future<void> _loadProduct() async {
    final id = int.tryParse(widget.productId);
    if (id == null) {
      setState(() => _isLoading = false);
      return;
    }

    final product = await ProductService.getProductById(id);
    setState(() {
      _product = product;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF6F8F6),
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_product == null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline,
                    size: 64, color: AppColors.sage400),
                const SizedBox(height: 16),
                const Text(
                  'Không tìm thấy sản phẩm',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Quay lại'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Stack(
        children: [
          // Scrollable content
          CustomScrollView(
            slivers: [
              // Hero Image
              SliverToBoxAdapter(
                child: _buildHeroSection(),
              ),

              // Content Body
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 140),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Price
                      _buildTitlePriceSection(),
                      const SizedBox(height: 24),

                      // Info Cards
                      _buildInfoCards(),
                      const SizedBox(height: 28),

                      // Description
                      _buildDescriptionSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Sticky Bottom Action Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomActionBar(),
          ),
        ],
      ),
    );
  }

  /// Hero image section with rounded bottom corners
  Widget _buildHeroSection() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      decoration: const BoxDecoration(
        color: AppColors.sage100,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Plant image
          Image.network(
            _defaultImage,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Center(
              child:
                  Icon(Icons.local_florist, size: 80, color: AppColors.sage400),
            ),
          ),

          // Gradient overlay at top for buttons
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x33000000),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Back & Favorite buttons
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircleButton(
                  icon: Icons.arrow_back,
                  onTap: () => Navigator.of(context).pop(),
                ),
                _buildCircleButton(
                  icon:
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                  iconColor: _isFavorite ? Colors.red : Colors.white,
                  onTap: () =>
                      setState(() => _isFavorite = !_isFavorite),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Frosted glass circle button
  Widget _buildCircleButton({
    required IconData icon,
    Color iconColor = Colors.white,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0x33FFFFFF),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0x1AFFFFFF)),
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
    );
  }

  /// Title, category, price
  Widget _buildTitlePriceSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name + category
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _product!.productName,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _product!.categoryName,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                  color: AppColors.sage500,
                ),
              ),
            ],
          ),
        ),

        // Price
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${_product!.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            if (_product!.stockQuantity != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.inventory_2_outlined,
                      size: 14, color: AppColors.sage500),
                  const SizedBox(width: 4),
                  Text(
                    'Còn ${_product!.stockQuantity}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.sage500,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  /// Info cards: Category, Stock, Created
  Widget _buildInfoCards() {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            icon: Icons.category_outlined,
            label: 'Category',
            value: _product!.categoryName,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInfoCard(
            icon: Icons.inventory_outlined,
            label: 'Stock',
            value: '${_product!.stockQuantity ?? 0} items',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInfoCard(
            icon: Icons.calendar_today_outlined,
            label: 'Added',
            value: _product!.createdAt != null
                ? '${_product!.createdAt!.day}/${_product!.createdAt!.month}/${_product!.createdAt!.year}'
                : 'N/A',
          ),
        ),
      ],
    );
  }

  /// Single info card
  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
        border: Border.all(color: AppColors.sage100),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFF4F7F4),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 22, color: AppColors.sage500),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppColors.sage500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Description section
  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        _buildDetailRow('Tên sản phẩm', _product!.productName),
        _buildDetailRow('Danh mục', _product!.categoryName),
        _buildDetailRow('Giá', '\$${_product!.price.toStringAsFixed(2)}'),
        _buildDetailRow('Tồn kho', '${_product!.stockQuantity ?? 0}'),
        _buildDetailRow(
          'Ngày tạo',
          _product!.createdAt != null
              ? '${_product!.createdAt!.day}/${_product!.createdAt!.month}/${_product!.createdAt!.year}'
              : 'N/A',
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.sage500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Sticky bottom bar with quantity stepper + Add to Cart
  Widget _buildBottomActionBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xE6FFFFFF),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        border: const Border(
          top: BorderSide(color: AppColors.sage100, width: 1),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      child: Row(
        children: [
          // Quantity Stepper
          Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(AppDimens.radiusFull),
              border: Border.all(color: AppColors.sage100),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    if (_quantity > 1) {
                      setState(() => _quantity--);
                    }
                  },
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child: Icon(
                      Icons.remove,
                      size: 18,
                      color: _quantity > 1
                          ? AppColors.textPrimary
                          : AppColors.sage400,
                    ),
                  ),
                ),
                SizedBox(
                  width: 28,
                  child: Text(
                    '$_quantity',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _quantity++),
                  child: const SizedBox(
                    width: 28,
                    height: 28,
                    child: Icon(
                      Icons.add,
                      size: 18,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Add to Cart Button
          Expanded(
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        '${_product!.productName} x$_quantity added to cart!'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimens.radiusM),
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius:
                      BorderRadius.circular(AppDimens.radiusFull),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x4D13EC13),
                      blurRadius: 16,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_bag_outlined,
                        size: 22, color: AppColors.textPrimary),
                    SizedBox(width: 8),
                    Text(
                      'Add to Cart',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
