import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';

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
  bool _isDescriptionExpanded = false;

  // TODO: Replace with real data from BLoC/repository
  final Map<String, dynamic> _product = {
    'name': 'Fiddle Leaf Fig',
    'scientificName': 'Ficus lyrata',
    'price': 45.00,
    'rating': 4.8,
    'image':
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDRgK_fIBMNXt0eUOTItxnJQGo3Lw55z36pcP0Zzwo5vsw77vVCwTPPbdWyA6ekcgn48QQmhA5su_tMsjm2C-jqd5XTWNX65fspQX0_DJC80u8BIEjgCFfRfVJbddifGb6rj7Cg99bJDFpYYWtD57vt7c2AdtFx0tt-6GN91tOaip4yvTN9wnQaT1YGfSZqNRzCsibznKzfFVo7_lq8VkB9Le8cM0aV6qJcHe2ImdQ9WZ0bZKMnkTDwqjP-yDKteyxZmH9uqRkxJHcc',
    'description':
        'The Fiddle Leaf Fig is a popular indoor tree featuring very large, heavily veined, and violin-shaped leaves that grow upright. It brings a dramatic structural element to any bright room.',
    'water': 'Every 7 days',
    'light': 'Bright indirect',
    'temp': '18°C - 24°C',
  };

  @override
  Widget build(BuildContext context) {
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

                      // Care Stats
                      _buildCareStats(),
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
            _product['image'],
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Center(
              child: Icon(Icons.local_florist, size: 80, color: AppColors.sage400),
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
                  icon: _isFavorite ? Icons.favorite : Icons.favorite_border,
                  iconColor: _isFavorite ? Colors.red : Colors.white,
                  onTap: () => setState(() => _isFavorite = !_isFavorite),
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

  /// Title, scientific name, price, and rating
  Widget _buildTitlePriceSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name + scientific name
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _product['name'],
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _product['scientificName'],
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

        // Price + Rating
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${_product['price'].toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, size: 16, color: Color(0xFFEAB308)),
                const SizedBox(width: 3),
                Text(
                  '${_product['rating']}',
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

  /// 3-column care stats (Water, Light, Temp)
  Widget _buildCareStats() {
    return Row(
      children: [
        Expanded(
          child: _buildCareCard(
            icon: Icons.water_drop_outlined,
            label: 'Water',
            value: _product['water'],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildCareCard(
            icon: Icons.wb_sunny_outlined,
            label: 'Light',
            value: _product['light'],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildCareCard(
            icon: Icons.thermostat_outlined,
            label: 'Temp',
            value: _product['temp'],
          ),
        ),
      ],
    );
  }

  /// Single care stat card
  Widget _buildCareCard({
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
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7F4),
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

  /// Description section with "Read more" toggle
  Widget _buildDescriptionSection() {
    final description = _product['description'] as String;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          description,
          maxLines: _isDescriptionExpanded ? null : 3,
          overflow:
              _isDescriptionExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.sage500,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            setState(() => _isDescriptionExpanded = !_isDescriptionExpanded);
          },
          child: Text(
            _isDescriptionExpanded ? 'Show less' : 'Read more',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
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
        border: Border(
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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                        '${_product['name']} x$_quantity added to cart!'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.radiusM),
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppDimens.radiusFull),
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
