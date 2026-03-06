import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../viewmodels/admin_product_viewmodel.dart';

import '../models/product.dart';
import '../services/app_constants.dart';
import '../services/auth_storage.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int _selectedCategoryIndex = 0;

  final List<String> _plantImages = [
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBO5gVKfk_EARRddUC-mT6bfXTogBpEGs1JXuJZve9kDIBD9tgJYYTPVeeZgqh1W3KEFLQxVfZbAIldaZX7RWd4NISNavDzPYol2vlSwOc57uP5ci2rHUA9JVByHAUVkN1kB2uzM-U-yYYP3gQUge9c4W3iX56orjj7GlZKtHkWJlx0YbyhJ45uhA_ULDIpifb-kEAdukCplD8ME9xyXpno2v5avTD-xKJrfNud9OZpNjaRgNxWOeBVFE_gjZwOjhgMatjdg0XYwe4L',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuCQ7v2MXryRMintEKHNasoTjSk7uBJaIzd3qab7LfB11N-cehkCPS9VXm_CVw61aez9ght-skWXwwrCn3ez4u62FzUGH1YhGxTYxQNy0OWq3Jybi-Y8E0ReE0MFFDRAoClPdgIJNhtGD1b275x8eXKeyQF-v465eravTv8YcIDFTv20P1AqQyLOMSw7uJp1T8SgospybAbl2wh0oWbxNfflFvZNBVCaQUt9SrJR2o_VGJqlPQ2pG58hy5J3H4RmyJCi9Y6iJ581l3ak',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBwhBVLXbbuhXkDsushY0au_2T2xFlXGcwQ15oQgz0_npCLuzNDu8Ms5VrliDG4rG1zGpOa7v75e5XzaekszmlP-NtixtnXghB8dN2bO4LJFvWfYlOBh4XlauNiUVeMy4G3BNb-1-Gly35zWP44yZlawSbpPvYNG5Fqea38JzPNt74RHVpP0ESEbv10Vet4wbX2yOBxBOQDu3snIDxpl672FiqnI1hq2H2PhOJciihwtP3VxTmd6MrB9ClLTg4JWQ34MbZO6FWjAV5y',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAukzQxTumhhcbQTgUj5ydrgeknzIo088LNT3kwpfaxroqFqgQJJpw-iG3WOEdkdT9lKrJEELvNiTeJAqxLDPvY3OIiaAXRlhH0_U8ruAbQBgjvwOVy-9DCyT37PdPNjhKJpIk5Tl7m_pb7UsU-DYVYqWZbDPk_NhZukOCv1CuuQIOoAumxcEhREk8HpdpEvcF3wleu0wbZQPJWqGw42T8yXPBU4yo_ZRsGy1GhQ1s0kYgIjZ-SsJz_3BPiblSTrB-LviLB45u7tVS',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProductViewModel>().initialize();
    });
  }

  List<Product> _getFilteredProducts(
    List<Product> products,
    List<String> categoryNames,
  ) {
    if (_selectedCategoryIndex == 0) return products;
    final selectedCategoryName = categoryNames[_selectedCategoryIndex];
    return products
        .where((p) => p.categoryName == selectedCategoryName)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final username = AuthStorage.username ?? 'Người yêu cây';
    final theme = Theme.of(context);

    // Dynamic greeting based on time
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Chào buổi sáng'
        : hour < 18
        ? 'Chào buổi chiều'
        : 'Chào buổi tối';

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      child: Consumer<AdminProductViewModel>(
        builder: (context, viewModel, child) {
          final categoryNames = [
            AppStrings.all,
            ...viewModel.categories.map((c) => c.categoryName),
          ];
          final filteredProducts = _getFilteredProducts(
            viewModel.products,
            categoryNames,
          );

          return SafeArea(
            child: CustomScrollView(
              slivers: [
                // Header Section
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$greeting, $username 🌿',
                                style: theme.typography.small.copyWith(
                                  color: const Color(0xFF166534),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                AppStrings.findYourPlant,
                                style: theme.typography.h2.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF14532D),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(LucideIcons.bell, size: 20),
                            onPressed: () {},
                            variance: ButtonVariance.ghost,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Hero Banner Section
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF16A34A), Color(0xFF15803D)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF16A34A,
                            ).withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Giảm giá 30%', // "30% off"
                                  style: theme.typography.small.copyWith(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Khám phá\nbộ sưu tập mới', // "Discover new collection"
                                  style: theme.typography.h3.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                OutlineButton(
                                  onPressed: () {},
                                  child: const Text('Khám phá ngay'),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 100,
                              alignment: Alignment.centerRight,
                              child: Icon(
                                LucideIcons.leaf,
                                size: 80,
                                color: Colors.white.withValues(alpha: 0.24),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Search Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),

                // Categories Chips
                SliverToBoxAdapter(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: List.generate(categoryNames.length, (index) {
                        final isSelected = _selectedCategoryIndex == index;
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: isSelected
                              ? PrimaryButton(
                                  onPressed: () => setState(
                                    () => _selectedCategoryIndex = index,
                                  ),
                                  child: Text(
                                    categoryNames[index],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              : OutlineButton(
                                  onPressed: () => setState(
                                    () => _selectedCategoryIndex = index,
                                  ),
                                  child: Text(
                                    categoryNames[index],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                        );
                      }),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),

                // Product Grid or Loading
                if (viewModel.isLoadingProducts && filteredProducts.isEmpty)
                  const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(60),
                        child: CircularProgressIndicator(
                          color: Color(0xFF16A34A),
                        ),
                      ),
                    ),
                  )
                else if (filteredProducts.isEmpty)
                  SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(60),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                LucideIcons.leaf,
                                size: 48,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Chưa có sản phẩm nào',
                              style: theme.typography.base.copyWith(
                                color: const Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.72,
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final product = filteredProducts[index];
                        final imageUrl =
                            product.imageUrl ??
                            _plantImages[index % _plantImages.length];

                        return GestureDetector(
                          onTap: () => context.push('/product/${product.id}'),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                              top: Radius.circular(20),
                                            ),
                                        child: Container(
                                          width: double.infinity,
                                          color: const Color(0xFFF1F5F9),
                                          child: Image.network(
                                            imageUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      // Favorite Icon Button overlay
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(
                                              alpha: 0.9,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            LucideIcons.heart,
                                            size: 16,
                                            color: Color(0xFF64748B),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.categoryName,
                                              style: theme.typography.small
                                                  .copyWith(
                                                    color: const Color(
                                                      0xFF64748B,
                                                    ),
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 0.5,
                                                  ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              product.productName,
                                              style: theme.typography.base
                                                  .copyWith(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                    color: const Color(
                                                      0xFF0F172A,
                                                    ),
                                                  ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '\$${product.price}',
                                              style: theme.typography.base
                                                  .copyWith(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w800,
                                                    color: const Color(
                                                      0xFF16A34A,
                                                    ),
                                                  ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF16A34A),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                LucideIcons.plus,
                                                size: 12,
                                                color: Colors.white,
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
                      }, childCount: filteredProducts.length),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          );
        },
      ),
    );
  }
}
