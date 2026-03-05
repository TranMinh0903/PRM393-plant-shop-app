import 'package:flutter/material.dart' as m;
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:go_router/go_router.dart';

import '../models/product.dart';
import '../models/category.dart';
import '../services/app_constants.dart';
import '../services/auth_storage.dart';
import '../repositories/product_repo.dart';
import '../services/category_service.dart';

class ProductScreen extends m.StatefulWidget {
  const ProductScreen({super.key});

  @override
  m.State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends m.State<ProductScreen> {
  int _selectedCategoryIndex = 0;
  bool _isLoading = true;

  List<Product> _products = [];
  List<String> _categoryNames = [AppStrings.all];

  final List<String> _plantImages = [
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBO5gVKfk_EARRddUC-mT6bfXTogBpEGs1JXuJZve9kDIBD9tgJYYTPVeeZgqh1W3KEFLQxVfZbAIldaZX7RWd4NISNavDzPYol2vlSwOc57uP5ci2rHUA9JVByHAUVkN1kB2uzM-U-yYYP3gQUge9c4W3iX56orjj7GlZKtHkWJlx0YbyhJ45uhA_ULDIpifb-kEAdukCplD8ME9xyXpno2v5avTD-xKJrfNud9OZpNjaRgNxWOeBVFE_gjZwOjhgMatjdg0XYwe4L',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuCQ7v2MXryRMintEKHNasoTjSk7uBJaIzd3qab7LfB11N-cehkCPS9VXm_CVw61aez9ght-skWXwwrCn3ez4u62FzUGH1YhGxTYxQNy0OWq3Jybi-Y8E0ReE0MFFDRAoClPdgIJNhtGD1b275x8eXKeyQF-v465eravTv8YcIDFTv20P1AqQyLOMSw7uJp1T8SgospybAbl2wh0oWbxNfflFvZNBVCaQUt9SrJR2o_VGJqlPQ2pG58hy5J3H4RmyJCi9Y6iJ581l3ak',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBwhBVLXbbuhXkDsushY0au_2T2xFlXGcwQ15oQgz0_npCLuzNDu8Ms5VrliDG4rG1zGpOa7v75e5XzaekszmlP-NtixtnXghB8dN2bO4LJFvWfYlOBh4XlauNiUVeMy4G3BNb-1-Gly35zWP44yZlawSbpPvYNG5Fqea38JzPNt74RHVpP0ESEbv10Vet4wbX2yOBxBOQDu3snIDxpl672FiqnI1hq2H2PhOJciihwtP3VxTmd6MrB9ClLTg4JWQ34MbZO6FWjAV5y',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAukzQxTumhhcbQTgUj5ydrgeknzIo088LNT3kwpfaxroqFqgQJJpw-iG3WOEdkdT9lKrJEELvNiTeJAqxLDPvY3OIiaAXRlhH0_U8ruAbQBgjvwOVy-9DCyT37PdPNjhKJpIk5Tl7m_pb7UsU-DYVYqWZbDPk_NhZukOCv1CuuQIOoAumxcEhREk8HpdpEvcF3wleu0wbZQPJWqGw42T8yXPBU4yo_ZRsGy1GhQ1s0kYgIjZ-SsJz_3BPiblSTrB-LviLB45u7tVS',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final results = await Future.wait([
      ProductRepo.getProducts(pageSize: 20),
      CategoryService.getCategories(),
    ]);

    final products = results[0] as List<Product>;
    final categories = results[1] as List<Category>;

    if (mounted) {
      setState(() {
        _products = products;
        _categoryNames = [
          AppStrings.all,
          ...categories.map((c) => c.categoryName),
        ];
        _isLoading = false;
      });
    }
  }

  List<Product> get _filteredProducts {
    if (_selectedCategoryIndex == 0) return _products;
    final selectedCategoryName = _categoryNames[_selectedCategoryIndex];
    return _products
        .where((p) => p.categoryName == selectedCategoryName)
        .toList();
  }

  @override
  m.Widget build(m.BuildContext context) {
    final username = AuthStorage.username ?? 'Người yêu cây';
    final theme = Theme.of(context);

    // Dynamic greeting based on time
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Chào buổi sáng'
        : hour < 18
        ? 'Chào buổi chiều'
        : 'Chào buổi tối';

    return m.Scaffold(
      backgroundColor: const m.Color(0xFFFAFAFA),
      body: m.SafeArea(
        child: m.CustomScrollView(
          slivers: [
            // Header Section
            m.SliverPadding(
              padding: const m.EdgeInsets.fromLTRB(24, 24, 24, 16),
              sliver: m.SliverToBoxAdapter(
                child: m.Row(
                  mainAxisAlignment: m.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: m.CrossAxisAlignment.center,
                  children: [
                    m.Expanded(
                      child: m.Column(
                        crossAxisAlignment: m.CrossAxisAlignment.start,
                        children: [
                          m.Text(
                            '$greeting, $username 🌿',
                            style: theme.typography.small.copyWith(
                              color: const m.Color(0xFF166534),
                              fontWeight: m.FontWeight.w600,
                            ),
                          ),
                          const m.SizedBox(height: 2),
                          m.Text(
                            AppStrings.findYourPlant,
                            style: theme.typography.h2.copyWith(
                              fontWeight: m.FontWeight.w800,
                              color: const m.Color(0xFF14532D),
                            ),
                            maxLines: 2,
                            overflow: m.TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const m.SizedBox(width: 16),
                    m.Container(
                      decoration: m.BoxDecoration(
                        color: m.Colors.white,
                        shape: m.BoxShape.circle,
                        boxShadow: [
                          m.BoxShadow(
                            color: m.Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const m.Offset(0, 4),
                          ),
                        ],
                      ),
                      child: m.IconButton(
                        icon: const Icon(LucideIcons.bell, size: 20),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Hero Banner Section
            m.SliverPadding(
              padding: const m.EdgeInsets.symmetric(horizontal: 24),
              sliver: m.SliverToBoxAdapter(
                child: m.Container(
                  margin: const m.EdgeInsets.only(bottom: 24),
                  padding: const m.EdgeInsets.all(24),
                  decoration: m.BoxDecoration(
                    gradient: const m.LinearGradient(
                      colors: [m.Color(0xFF16A34A), m.Color(0xFF15803D)],
                      begin: m.Alignment.topLeft,
                      end: m.Alignment.bottomRight,
                    ),
                    borderRadius: m.BorderRadius.circular(24),
                    boxShadow: [
                      m.BoxShadow(
                        color: const m.Color(0xFF16A34A).withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const m.Offset(0, 10),
                      ),
                    ],
                  ),
                  child: m.Row(
                    children: [
                      m.Expanded(
                        flex: 3,
                        child: m.Column(
                          crossAxisAlignment: m.CrossAxisAlignment.start,
                          children: [
                            m.Text(
                              'Giảm giá 30%', // "30% off"
                              style: theme.typography.small.copyWith(
                                color: m.Colors.white.withValues(alpha: 0.8),
                                fontWeight: m.FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const m.SizedBox(height: 8),
                            m.Text(
                              'Khám phá\nbộ sưu tập mới', // "Discover new collection"
                              style: theme.typography.h3.copyWith(
                                color: m.Colors.white,
                                fontWeight: m.FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                            const m.SizedBox(height: 16),
                            OutlineButton(
                              onPressed: () {},
                              child: const m.Text('Khám phá ngay'),
                            ),
                          ],
                        ),
                      ),
                      m.Expanded(
                        flex: 2,
                        child: m.Container(
                          height: 100,
                          alignment: m.Alignment.centerRight,
                          child: const Icon(
                            LucideIcons.leaf,
                            size: 80,
                            color: m.Colors.white24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Search Bar
            m.SliverToBoxAdapter(
              child: m.Padding(
                padding: const m.EdgeInsets.symmetric(horizontal: 24),
                child: m.Container(
                  decoration: m.BoxDecoration(
                    boxShadow: [
                      m.BoxShadow(
                        color: m.Colors.black.withValues(alpha: 0.03),
                        blurRadius: 15,
                        offset: const m.Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextField(
                    placeholder: m.Text(AppStrings.searchHint),
                    features: const [
                      InputLeadingFeature(
                        Icon(LucideIcons.search, color: m.Color(0xFF16A34A)),
                      ),
                      InputTrailingFeature(
                        Icon(LucideIcons.settings2, color: m.Color(0xFF94A3B8)),
                      ), // filter icon
                    ],
                  ),
                ),
              ),
            ),
            const m.SliverToBoxAdapter(child: m.SizedBox(height: 24)),

            // Categories Chips
            m.SliverToBoxAdapter(
              child: m.SingleChildScrollView(
                scrollDirection: m.Axis.horizontal,
                padding: const m.EdgeInsets.symmetric(horizontal: 24),
                child: m.Row(
                  children: List.generate(_categoryNames.length, (index) {
                    final isSelected = _selectedCategoryIndex == index;
                    return m.Padding(
                      padding: const m.EdgeInsets.only(right: 12),
                      child: isSelected
                          ? PrimaryButton(
                              onPressed: () => setState(
                                () => _selectedCategoryIndex = index,
                              ),
                              child: m.Text(
                                _categoryNames[index],
                                style: const m.TextStyle(
                                  fontWeight: m.FontWeight.w600,
                                ),
                              ),
                            )
                          : OutlineButton(
                              onPressed: () => setState(
                                () => _selectedCategoryIndex = index,
                              ),
                              child: m.Text(
                                _categoryNames[index],
                                style: const m.TextStyle(
                                  fontWeight: m.FontWeight.w500,
                                ),
                              ),
                            ),
                    );
                  }),
                ),
              ),
            ),
            const m.SliverToBoxAdapter(child: m.SizedBox(height: 24)),

            // Product Grid or Loading
            if (_isLoading)
              const m.SliverToBoxAdapter(
                child: m.Center(
                  child: m.Padding(
                    padding: m.EdgeInsets.all(60),
                    child: m.CircularProgressIndicator(
                      color: m.Color(0xFF16A34A),
                    ),
                  ),
                ),
              )
            else if (_filteredProducts.isEmpty)
              m.SliverToBoxAdapter(
                child: m.Center(
                  child: m.Padding(
                    padding: const m.EdgeInsets.all(60),
                    child: m.Column(
                      children: [
                        m.Container(
                          padding: const m.EdgeInsets.all(20),
                          decoration: m.BoxDecoration(
                            color: const m.Color(0xFFF1F5F9),
                            shape: m.BoxShape.circle,
                          ),
                          child: const Icon(
                            LucideIcons.leaf,
                            size: 48,
                            color: m.Color(0xFF94A3B8),
                          ),
                        ),
                        const m.SizedBox(height: 16),
                        m.Text(
                          'Chưa có sản phẩm nào',
                          style: theme.typography.base.copyWith(
                            color: const m.Color(0xFF64748B),
                            fontWeight: m.FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              m.SliverPadding(
                padding: const m.EdgeInsets.symmetric(horizontal: 24),
                sliver: m.SliverGrid(
                  gridDelegate:
                      const m.SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.72,
                      ),
                  delegate: m.SliverChildBuilderDelegate((context, index) {
                    final product = _filteredProducts[index];
                    final imageUrl =
                        product.imageUrl ??
                        _plantImages[index % _plantImages.length];

                    return m.GestureDetector(
                      onTap: () => context.push('/product/${product.id}'),
                      child: m.Container(
                        decoration: m.BoxDecoration(
                          color: m.Colors.white,
                          borderRadius: m.BorderRadius.circular(20),
                          boxShadow: [
                            m.BoxShadow(
                              color: m.Colors.black.withValues(alpha: 0.04),
                              blurRadius: 20,
                              offset: const m.Offset(0, 10),
                            ),
                          ],
                        ),
                        child: m.Column(
                          crossAxisAlignment: m.CrossAxisAlignment.start,
                          children: [
                            m.Expanded(
                              flex: 5,
                              child: m.Stack(
                                children: [
                                  m.ClipRRect(
                                    borderRadius: const m.BorderRadius.vertical(
                                      top: m.Radius.circular(20),
                                    ),
                                    child: m.Container(
                                      width: double.infinity,
                                      color: const m.Color(0xFFF1F5F9),
                                      child: m.Image.network(
                                        imageUrl,
                                        fit: m.BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  // Favorite Icon Button overlay
                                  m.Positioned(
                                    top: 8,
                                    right: 8,
                                    child: m.Container(
                                      padding: const m.EdgeInsets.all(6),
                                      decoration: m.BoxDecoration(
                                        color: m.Colors.white.withValues(
                                          alpha: 0.9,
                                        ),
                                        shape: m.BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        LucideIcons.heart,
                                        size: 16,
                                        color: m.Color(0xFF64748B),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            m.Expanded(
                              flex: 3,
                              child: m.Padding(
                                padding: const m.EdgeInsets.all(8),
                                child: m.Column(
                                  crossAxisAlignment:
                                      m.CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      m.MainAxisAlignment.spaceBetween,
                                  children: [
                                    m.Column(
                                      crossAxisAlignment:
                                          m.CrossAxisAlignment.start,
                                      children: [
                                        m.Text(
                                          product.categoryName,
                                          style: theme.typography.small
                                              .copyWith(
                                                color: const m.Color(
                                                  0xFF64748B,
                                                ),
                                                fontSize: 10,
                                                fontWeight: m.FontWeight.w600,
                                                letterSpacing: 0.5,
                                              ),
                                        ),
                                        const m.SizedBox(height: 2),
                                        m.Text(
                                          product.productName,
                                          style: theme.typography.base.copyWith(
                                            fontSize: 13, fontWeight: m.FontWeight.w700,
                                            color: const m.Color(0xFF0F172A),
                                          ),
                                          maxLines: 1,
                                          overflow: m.TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    m.Row(
                                      mainAxisAlignment:
                                          m.MainAxisAlignment.spaceBetween,
                                      children: [
                                        m.Text(
                                          '\$${product.price}',
                                          style: theme.typography.base.copyWith(
                                            fontSize: 14,
                                            fontWeight: m.FontWeight.w800,
                                            color: const m.Color(0xFF16A34A),
                                          ),
                                        ),
                                        m.Container(
                                          padding: const m.EdgeInsets.all(6),
                                          decoration: const m.BoxDecoration(
                                            color: m.Color(0xFF16A34A),
                                            shape: m.BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            LucideIcons.plus,
                                            size: 12,
                                            color: m.Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }, childCount: _filteredProducts.length),
                ),
              ),
            const m.SliverToBoxAdapter(child: m.SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}
