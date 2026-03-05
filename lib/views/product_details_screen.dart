import 'package:flutter/material.dart' as m;
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:go_router/go_router.dart';

import '../models/product.dart';
import '../repositories/product_repo.dart';

class ProductDetailsScreen extends m.StatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  m.State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends m.State<ProductDetailsScreen> {
  int _quantity = 1;
  bool _isLoading = true;
  Product? _product;

  final String _defaultImage =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDRgK_fIBMNXt0eUOTItxnJQGo3Lw55z36pcP0Zzwo5vsw77vVCwTPPbdWyA6ekcgn48QQmhA5su_tMsjm2C-jqd5XTWNX65fspQX0_DJC80u8BIEjgCFfRfVJbddifGb6rj7Cg99bJDFpYYWtD57vt7c2AdtFx0tt-6GN91tOaip4yvTN9wnQaT1YGfSZqNRzCsibznKzfFVo7_lq8VkB9Le8cM0aV6qJcHe2ImdQ9WZ0bZKMnkTDwqjP-yDKteyxZmH9uqRkxJHcc';

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    final id = int.tryParse(widget.productId);
    if (id == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    final product = await ProductRepo.getProductById(id);
    if (mounted) {
      setState(() {
        _product = product;
        _isLoading = false;
      });
    }
  }

  @override
  m.Widget build(m.BuildContext context) {
    if (_isLoading) {
      return const m.Scaffold(
        body: m.Center(child: m.CircularProgressIndicator()),
      );
    }

    if (_product == null) {
      return m.Scaffold(
        appBar: m.AppBar(title: const m.Text('Lỗi')),
        body: m.Center(
          child: m.Column(
            mainAxisAlignment: m.MainAxisAlignment.center,
            children: [
              const Icon(LucideIcons.triangleAlert, size: 48),
              const m.SizedBox(height: 16),
              const m.Text('Không tìm thấy sản phẩm'),
              const m.SizedBox(height: 16),
              PrimaryButton(
                onPressed: () => context.pop(),
                child: const m.Text('Quay lại'),
              ),
            ],
          ),
        ),
      );
    }

    final theme = Theme.of(context);
    return m.Scaffold(
      body: m.Stack(
        children: [
          m.CustomScrollView(
            slivers: [
              m.SliverToBoxAdapter(
                child: m.Stack(
                  children: [
                    m.Image.network(
                      _product!.imageUrl ?? _defaultImage,
                      height: 400,
                      width: double.infinity,
                      fit: m.BoxFit.cover,
                    ),
                    m.Positioned(
                      top: m.MediaQuery.of(context).padding.top + 8,
                      left: 16,
                      child: GhostButton(
                        onPressed: () => context.pop(),
                        child: const Icon(LucideIcons.chevronLeft, size: 24),
                      ),
                    ),
                  ],
                ),
              ),
              m.SliverPadding(
                padding: const m.EdgeInsets.all(24),
                sliver: m.SliverToBoxAdapter(
                  child: m.Column(
                    crossAxisAlignment: m.CrossAxisAlignment.start,
                    children: [
                      m.Row(
                        mainAxisAlignment: m.MainAxisAlignment.spaceBetween,
                        children: [
                          m.Expanded(
                            child: m.Column(
                              crossAxisAlignment: m.CrossAxisAlignment.start,
                              children: [
                                m.Text(
                                  _product!.productName,
                                  style: theme.typography.h1,
                                ),
                                m.Text(
                                  _product!.categoryName,
                                  style: theme.typography.textMuted,
                                ),
                              ],
                            ),
                          ),
                          m.Text(
                            '₫${_product!.price}',
                            style: theme.typography.h2.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const m.SizedBox(height: 24),
                      Text('Mô tả', style: theme.typography.h4),
                      const m.SizedBox(height: 8),
                      m.Text(
                        'Một loại cây cảnh tuyệt vời để trang trí không gian sống của bạn. Mang lại không khí trong lành và cảm giác thư thái.',
                        style: theme.typography.base,
                      ),
                      const m.SizedBox(height: 24),
                      m.Row(
                        mainAxisAlignment: m.MainAxisAlignment.spaceBetween,
                        children: [
                          m.Text('Số lượng', style: theme.typography.medium),
                          m.Row(
                            children: [
                              GhostButton(
                                onPressed: () {
                                  if (_quantity > 1) {
                                    setState(() => _quantity--);
                                  }
                                },
                                child: const Icon(LucideIcons.minus, size: 18),
                              ),
                              m.Padding(
                                padding: const m.EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: m.Text(
                                  '$_quantity',
                                  style: theme.typography.medium,
                                ),
                              ),
                              GhostButton(
                                onPressed: () => setState(() => _quantity++),
                                child: const Icon(LucideIcons.plus, size: 18),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          m.Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: m.Container(
              padding: m.EdgeInsets.fromLTRB(
                24,
                16,
                24,
                m.MediaQuery.of(context).padding.bottom + 16,
              ),
              decoration: m.BoxDecoration(
                color: theme.colorScheme.background,
                border: m.Border(
                  top: m.BorderSide(color: theme.colorScheme.border),
                ),
              ),
              child: PrimaryButton(
                onPressed: () {
                  m.ScaffoldMessenger.of(context).showSnackBar(
                    m.SnackBar(
                      content: m.Text(
                        'Đã thêm $_quantity ${_product!.productName} vào giỏ hàng',
                      ),
                    ),
                  );
                },
                child: const m.Text('Thêm vào giỏ hàng'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
