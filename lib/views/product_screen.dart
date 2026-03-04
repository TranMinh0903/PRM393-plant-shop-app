import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/product.dart';
import '../models/category.dart';
import '../services/app_constants.dart';
import '../services/auth_storage.dart';
import '../repositories/product_repo.dart';
import '../services/category_service.dart';
import '../widgets/plant_card.dart';
import '../widgets/category_chip.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/promo_banner.dart';

/// Product screen - main screen hiển thị danh sách sản phẩm
class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int _selectedCategoryIndex = 0;
  bool _isLoading = true;

  List<Product> _products = [];
  List<Category> _apiCategories = [];
  List<String> _categoryNames = [AppStrings.all];

  // Danh sách ảnh minh họa cho sản phẩm (vì API chưa có trường image)
  final List<String> _plantImages = [
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBO5gVKfk_EARRddUC-mT6bfXTogBpEGs1JXuJZve9kDIBD9tgJYYTPVeeZgqh1W3KEFLQxVfZbAIldaZX7RWd4NISNavDzPYol2vlSwOc57uP5ci2rHUA9JVByHAUVkN1kB2uzM-U-yYYP3gQUge9c4W3iX56orjj7GlZKtHkWJlx0YbyhJ45uhA_ULDIpifb-kEAdukCplD8ME9xyXpno2v5avTD-xKJrfNud9OZpNjaRgNxWOeBVFE_gjZwOjhgMatjdg0XYwe4L',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuCQ7v2MXryRMintEKHNasoTjSk7uBJaIzd3qab7LfB11N-cehkCPS9VXm_CVw61aez9ght-skWXwwrCn3ez4u62FzUGH1YhGxTYxQNy0OWq3Jybi-Y8E0ReE0MFFDRAoClPdgIJNhtGD1b275x8eXKeyQF-v465eravTv8YcIDFTv20P1AqQyLOMSw7uJp1T8SgospybAbl2wh0oWbxNfflFvZNBVCaQUt9SrJR2o_VGJqlPQ2pG58hy5J3H4RmyJCi9Y6iJ581l3ak',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBwhBVLXbbuhXkDsushY0au_2T2xFlXGcwQ15oQgz0_npCLuzNDu8Ms5VrliDG4rG1zGpOa7v75e5XzaekszmlP-NtixtnXghB8dN2bO4LJFvWfYlOBh4XlauNiUVeMy4G3BNb-1-Gly35zWP44yZlawSbpPvYNG5Fqea38JzPNt74RHVpP0ESEbv10Vet4wbX2yOBxBOQDu3snIDxpl672FiqnI1hq2H2PhOJciihwtP3VxTmd6MrB9ClLTg4JWQ34MbZO6FWjAV5y',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAukzQxTumhhcbQTgUj5ydrgeknzIo088LNT3kwpfkaxroqFqgQJJpw-iG3WOEdkdT9lKrJEELvNiTeJAqxLDPvY3OIiaAXRlhH0_U8ruAbQBgjvwOVy-9DCyT37PdPNjhKJpIk5Tl7m_pb7UsU-DYVYqWZbDPk_NhZukOCv1CuuQIOoAumxcEhREk8HpdpEvcF3wleu0wbZQPJWqGw42T8yXPBU4yo_ZRsGy1GhQ1s0kYgIjZ-SsJz_3BPiblSTrB-LviLB45u7tVS',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Load products và categories từ BE Tree API
  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    // Load đồng thời products và categories
    final results = await Future.wait([
      ProductRepo.getProducts(pageSize: 20),
      CategoryService.getCategories(),
    ]);

    final products = results[0] as List<Product>;
    final categories = results[1] as List<Category>;

    setState(() {
      _products = products;
      _apiCategories = categories;
      _categoryNames = [
        AppStrings.all,
        ...categories.map((c) => c.categoryName),
      ];
      _isLoading = false;
    });
  }

  /// Filter products theo category đã chọn
  List<Product> get _filteredProducts {
    if (_selectedCategoryIndex == 0) return _products; // "All"
    final selectedCategoryName = _categoryNames[_selectedCategoryIndex];
    return _products
        .where((p) => p.categoryName == selectedCategoryName)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final username = AuthStorage.username ?? 'Plant Lover';

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, $username 🌿',
                          style: TextStyle(
                            color: AppColors.sage500,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          AppStrings.findYourPlant,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    // Notification bell
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x0D000000),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.notifications_outlined,
                            color: AppColors.textPrimary,
                            size: 24,
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 12,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.surface,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Search bar
            SliverPersistentHeader(
              pinned: true,
              delegate: _SearchBarDelegate(),
            ),

            // Promo Banner
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: PromoBanner(
                  imageUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuA0dIuEygoC1E2px02yXUBCSVXhzNqrd7UFeVFENTvDEAub2nQeKvbc5CJ0JSv0X7ntm1NtmaUBdDVn-qfSCql_HTKqZ2YhbBhl6R9PIi4tHNqjLdP_8s-rYLowGp620xOKS2_OZeEBhPDcLjacQV8SVQFpfy1-HnDwd6j7AbVGdtt6taKiRTMsX_mBnpleurQjscoz6SFnvEjmHo5czFwOiS6qmlbVCaUvoKLJ2hb6EMMN5mpqiBt7J3ckkv800Tw490XAnmqHUOsF',
                  onTap: () {
                    if (_products.isNotEmpty) {
                      context.push('/product/${_products.first.id}');
                    }
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Categories (từ API)
            SliverToBoxAdapter(
              child: CategoryChips(
                categories: _categoryNames,
                selectedIndex: _selectedCategoryIndex,
                onSelected: (index) {
                  setState(() => _selectedCategoryIndex = index);
                },
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 28)),

            // "Popular Plants" header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isLoading
                          ? AppStrings.popularPlants
                          : '${AppStrings.popularPlants} (${_filteredProducts.length})',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // TODO: Navigate to see all plants
                      },
                      child: Text(
                        AppStrings.seeAll,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.sage500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Loading indicator or Product Grid
            if (_isLoading)
              const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              )
            else if (_filteredProducts.isEmpty)
              SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Icon(Icons.local_florist_outlined,
                            size: 64, color: AppColors.sage400),
                        const SizedBox(height: 16),
                        Text(
                          'Chưa có sản phẩm',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.sage500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Hãy thêm sản phẩm qua API hoặc Swagger UI',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.sage400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              // Product Grid (2 columns) - từ API
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.58,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = _filteredProducts[index];
                      final imageUrl = product.imageUrl ??
                          _plantImages[index % _plantImages.length];
                      return PlantCard(
                        name: product.productName,
                        subtitle: product.categoryName,
                        imageUrl: imageUrl,
                        price: product.price,
                        isFavorite: false,
                        onTap: () {
                          context.push('/product/${product.id}');
                        },
                        onAddToCart: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  '${product.productName} added to cart!'),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppDimens.radiusM),
                              ),
                            ),
                          );
                        },
                        onFavorite: () {},
                      );
                    },
                    childCount: _filteredProducts.length,
                  ),
                ),
              ),

            // Bottom spacing for nav bar
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

/// Persistent header delegate for the search bar
class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 72;

  @override
  double get maxExtent => 72;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: shrinkOffset > 0
          ? const Color(0xF2F6F8F6)
          : AppColors.backgroundLight,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: const PlantSearchBar(),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
