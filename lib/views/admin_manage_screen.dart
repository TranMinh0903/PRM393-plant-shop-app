import 'package:flutter/material.dart' as m;
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart' as sui;

import '../viewmodels/admin_product_viewmodel.dart';
import '../models/category.dart';

class AdminManageScreen extends m.StatefulWidget {
  const AdminManageScreen({super.key});

  @override
  m.State<AdminManageScreen> createState() => _AdminManageScreenState();
}

class _AdminManageScreenState extends m.State<AdminManageScreen> {
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    m.WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProductViewModel>().initialize();
    });
  }

  @override
  m.Widget build(m.BuildContext context) {
    final theme = Theme.of(context);

    return m.Scaffold(
      backgroundColor: const m.Color(0xFFF1F5F9), // Light modern background
      appBar: m.AppBar(
        title: m.Text(
          'Quản lý hệ thống',
          style: theme.typography.h3.copyWith(fontWeight: m.FontWeight.w700),
        ),
        backgroundColor: m.Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: m.Column(
        children: [
          m.Container(
            color: m.Colors.white,
            padding: const m.EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: m.Container(
              decoration: m.BoxDecoration(
                color: const m.Color(0xFFF1F5F9),
                borderRadius: m.BorderRadius.circular(12),
              ),
              child: m.Padding(
                padding: const m.EdgeInsets.all(4),
                child: m.Row(
                  children: [
                    m.Expanded(
                      child: m.GestureDetector(
                        onTap: () => setState(() => _selectedTab = 0),
                        child: m.Container(
                          padding: const m.EdgeInsets.symmetric(vertical: 12),
                          decoration: m.BoxDecoration(
                            color: _selectedTab == 0
                                ? m.Colors.white
                                : m.Colors.transparent,
                            borderRadius: m.BorderRadius.circular(8),
                            boxShadow: _selectedTab == 0
                                ? [
                                    m.BoxShadow(
                                      color: m.Colors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                      blurRadius: 4,
                                      offset: const m.Offset(0, 2),
                                    ),
                                  ]
                                : [],
                          ),
                          alignment: m.Alignment.center,
                          child: m.Text(
                            'Sản phẩm',
                            style: m.TextStyle(
                              fontWeight: _selectedTab == 0
                                  ? m.FontWeight.w700
                                  : m.FontWeight.w500,
                              color: _selectedTab == 0
                                  ? theme.colorScheme.primary
                                  : const m.Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ),
                    ),
                    m.Expanded(
                      child: m.GestureDetector(
                        onTap: () => setState(() => _selectedTab = 1),
                        child: m.Container(
                          padding: const m.EdgeInsets.symmetric(vertical: 12),
                          decoration: m.BoxDecoration(
                            color: _selectedTab == 1
                                ? m.Colors.white
                                : m.Colors.transparent,
                            borderRadius: m.BorderRadius.circular(8),
                            boxShadow: _selectedTab == 1
                                ? [
                                    m.BoxShadow(
                                      color: m.Colors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                      blurRadius: 4,
                                      offset: const m.Offset(0, 2),
                                    ),
                                  ]
                                : [],
                          ),
                          alignment: m.Alignment.center,
                          child: m.Text(
                            'Danh mục',
                            style: m.TextStyle(
                              fontWeight: _selectedTab == 1
                                  ? m.FontWeight.w700
                                  : m.FontWeight.w500,
                              color: _selectedTab == 1
                                  ? theme.colorScheme.primary
                                  : const m.Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          m.Expanded(
            child: _selectedTab == 0
                ? _buildProductsTab()
                : _buildCategoriesTab(),
          ),
        ],
      ),
    );
  }

  m.Widget _buildProductsTab() {
    return Consumer<AdminProductViewModel>(
      builder: (context, viewModel, child) {
        return m.Column(
          children: [
            m.Padding(
              padding: const m.EdgeInsets.all(16),
              child: PrimaryButton(
                onPressed: () => _showProductDialog(context, viewModel),
                child: m.Row(
                  mainAxisAlignment: m.MainAxisAlignment.center,
                  children: const [
                    Icon(LucideIcons.plus, size: 18),
                    m.SizedBox(width: 8),
                    m.Text('Thêm sản phẩm'),
                  ],
                ),
              ),
            ),

            m.Expanded(
              child: viewModel.isLoadingProducts
                  ? const m.Center(child: m.CircularProgressIndicator())
                  : viewModel.products.isEmpty
                  ? m.Center(child: const m.Text('Không có sản phẩm nào'))
                  : m.ListView.builder(
                      padding: const m.EdgeInsets.symmetric(horizontal: 16),
                      itemCount: viewModel.products.length,
                      itemBuilder: (context, index) {
                        final product = viewModel.products[index];
                        return _buildProductCard(context, product, viewModel);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  m.Widget _buildProductCard(
    m.BuildContext context,
    dynamic product,
    AdminProductViewModel viewModel,
  ) {
    final theme = Theme.of(context);
    final imageUrl =
        product.imageUrl ??
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCQ7v2MXryRMintEKHNasoTjSk7uBJaIzd3qab7LfB11N-cehkCPS9VXm_CVw61aez9ght-skWXwwrCn3ez4u62FzUGH1YhGxTYxQNy0OWq3Jybi-Y8E0ReE0MFFDRAoClPdgIJNhtGD1b275x8eXKeyQF-v465eravTv8YcIDFTv20P1AqQyLOMSw7uJp1T8SgospybAbl2wh0oWbxNfflFvZNBVCaQUt9SrJR2o_VGJqlPQ2pG58hy5J3H4RmyJCi9Y6iJ581l3ak';

    return m.Container(
      margin: const m.EdgeInsets.only(bottom: 16),
      decoration: m.BoxDecoration(
        color: m.Colors.white,
        borderRadius: m.BorderRadius.circular(16),
        boxShadow: [
          m.BoxShadow(
            color: m.Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const m.Offset(0, 4),
          ),
        ],
      ),
      child: m.Padding(
        padding: const m.EdgeInsets.all(12),
        child: m.Row(
          children: [
            // Thumbnail
            m.ClipRRect(
              borderRadius: m.BorderRadius.circular(12),
              child: m.Container(
                width: 80,
                height: 80,
                color: const m.Color(0xFFF1F5F9),
                child: m.Image.network(imageUrl, fit: m.BoxFit.cover),
              ),
            ),
            const m.SizedBox(width: 16),
            // Details
            m.Expanded(
              child: m.Column(
                crossAxisAlignment: m.CrossAxisAlignment.start,
                children: [
                  m.Text(
                    product.productName,
                    style: theme.typography.base.copyWith(
                      fontWeight: m.FontWeight.w700,
                      color: const m.Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: m.TextOverflow.ellipsis,
                  ),
                  const m.SizedBox(height: 4),
                  m.Text(
                    product.categoryName,
                    style: theme.typography.small.copyWith(
                      color: const m.Color(0xFF64748B),
                      fontWeight: m.FontWeight.w500,
                    ),
                  ),
                  const m.SizedBox(height: 4),
                  m.Text(
                    product.stockQuantity.toString(),
                    style: theme.typography.small.copyWith(
                      color: const m.Color(0xFF64748B),
                      fontWeight: m.FontWeight.w500,
                    ),
                  ),
                  const m.SizedBox(height: 8),
                  m.Text(
                    '\$${product.price}',
                    style: theme.typography.base.copyWith(
                      fontWeight: m.FontWeight.w800,
                      color: const m.Color(0xFF16A34A),
                    ),
                  ),
                ],
              ),
            ),
            // Actions
            m.Column(
              children: [
                m.Container(
                  width: 36,
                  height: 36,
                  decoration: m.BoxDecoration(
                    color: const m.Color(0xFFF1F5F9),
                    borderRadius: m.BorderRadius.circular(8),
                  ),
                  child: m.IconButton(
                    icon: const Icon(LucideIcons.pencil, size: 16),
                    onPressed: () => _showProductDialog(
                      context,
                      viewModel,
                      product: product,
                    ),
                    color: const m.Color(0xFF334155),
                  ),
                ),
                const m.SizedBox(height: 8),
                m.Container(
                  width: 36,
                  height: 36,
                  decoration: m.BoxDecoration(
                    color: const m.Color(0xFFFEF2F2),
                    borderRadius: m.BorderRadius.circular(8),
                  ),
                  child: m.IconButton(
                    icon: const Icon(LucideIcons.trash2, size: 16),
                    onPressed: () =>
                        _showDeleteConfirm(context, viewModel, product.id),
                    color: const m.Color(0xFFEF4444), // Tailwind Red 500
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showProductDialog(
    m.BuildContext context,
    AdminProductViewModel viewModel, {
    dynamic product,
  }) {
    final isEditing = product != null;
    if (isEditing) {
      viewModel.setEditMode(product);
    } else {
      viewModel.setCreateMode();
    }

    m.showDialog(
      context: context,
      builder: (context) => m.Dialog(
        backgroundColor: m.Colors.transparent,
        child: m.Container(
          width: 450,
          padding: const m.EdgeInsets.all(20),
          decoration: m.BoxDecoration(
            color: m.Colors.white,
            borderRadius: m.BorderRadius.circular(20),
            boxShadow: [
              m.BoxShadow(
                color: m.Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const m.Offset(0, 10),
              ),
            ],
          ),
          child: m.SingleChildScrollView(
            child: m.Column(
              mainAxisSize: m.MainAxisSize.min,
              crossAxisAlignment: m.CrossAxisAlignment.start,
              children: [
                m.Row(
                  mainAxisAlignment: m.MainAxisAlignment.spaceBetween,
                  children: [
                    m.Text(
                      isEditing ? 'Sửa Sản phẩm' : 'Thêm Sản phẩm',
                      style: Theme.of(context).typography.h4.copyWith(
                        fontWeight: m.FontWeight.w700,
                        color: const m.Color(0xFF0F172A),
                      ),
                    ),
                    m.IconButton(
                      icon: const Icon(
                        LucideIcons.x,
                        size: 20,
                        color: m.Color(0xFF64748B),
                      ),
                      onPressed: () => m.Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const m.SizedBox(height: 24),
                m.Text(
                  'TÊN SẢN PHẨM',
                  style: Theme.of(context).typography.small.copyWith(
                    fontWeight: m.FontWeight.w600,
                    color: const m.Color(0xFF64748B),
                    letterSpacing: 0.5,
                  ),
                ),
                const m.SizedBox(height: 8),
                TextField(
                  controller: m.TextEditingController(
                    text: viewModel.editingProductName,
                  ),
                  placeholder: const m.Text('Nhập tên sản phẩm...'),
                  onChanged: (v) => viewModel.setProductName(v),
                ),
                const m.SizedBox(height: 12),
                m.Text(
                  'MỨC GIÁ (₫)',
                  style: Theme.of(context).typography.small.copyWith(
                    fontWeight: m.FontWeight.w600,
                    color: const m.Color(0xFF64748B),
                    letterSpacing: 0.5,
                  ),
                ),
                const m.SizedBox(height: 8),
                TextField(
                  controller: m.TextEditingController(
                    text: viewModel.editingPrice?.toString(),
                  ),
                  placeholder: const m.Text('Ví dụ: 150000'),
                  keyboardType: const m.TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (v) => viewModel.setPrice(double.tryParse(v) ?? 0),
                ),
                const m.SizedBox(height: 12),
                m.Text(
                  'SỐ LƯỢNG TỒN KHO',
                  style: Theme.of(context).typography.small.copyWith(
                    fontWeight: m.FontWeight.w600,
                    color: const m.Color(0xFF64748B),
                    letterSpacing: 0.5,
                  ),
                ),
                const m.SizedBox(height: 8),
                TextField(
                  controller: m.TextEditingController(
                    text: viewModel.editingStockQuantity?.toString(),
                  ),
                  placeholder: const m.Text('Ví dụ: 100'),
                  keyboardType: const m.TextInputType.numberWithOptions(
                    decimal: false,
                  ),
                  onChanged: (v) =>
                      viewModel.setStockQuantity(int.tryParse(v) ?? 0),
                ),
                const m.SizedBox(height: 20),
                m.Container(
                  padding: const m.EdgeInsets.all(16),
                  decoration: m.BoxDecoration(
                    color: const m.Color(0xFFF8FAFC),
                    borderRadius: m.BorderRadius.circular(12),
                    border: m.Border.all(color: const m.Color(0xFFE2E8F0)),
                  ),
                  child: m.Column(
                    crossAxisAlignment: m.CrossAxisAlignment.start,
                    children: [
                      m.Text(
                        'DANH MỤC',
                        style: m.TextStyle(
                          fontSize: 12,
                          fontWeight: m.FontWeight.w700,
                          color: const m.Color(0xFF64748B),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const m.SizedBox(height: 12),
                      sui.ShadTheme(
                        data: sui.ShadThemeData(),
                        child: sui.ShadRadioGroup<int>(
                          initialValue: viewModel.editingCategoryId,
                          onChanged: (v) {
                            if (v != null) viewModel.setCategoryId(v);
                          },
                          items: viewModel.categories.map((c) {
                            return sui.ShadRadio<int>(
                              value: c.id,
                              label: m.Text(
                                c.categoryName,
                                style: const m.TextStyle(
                                  fontSize: 14,
                                  color: m.Color(0xFF0F172A),
                                  fontWeight: m.FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                const m.SizedBox(height: 24),
                m.Row(
                  mainAxisAlignment: m.MainAxisAlignment.end,
                  children: [
                    OutlineButton(
                      onPressed: () => m.Navigator.of(context).pop(),
                      child: const m.Text('Hủy bỏ'),
                    ),
                    const m.SizedBox(width: 12),
                    PrimaryButton(
                      onPressed: () async {
                        viewModel.clearError();
                        final success = isEditing
                            ? await viewModel.updateProduct(
                                id: product.id,
                                productName: viewModel.editingProductName ?? '',
                                price: viewModel.editingPrice ?? 0,
                                stockQuantity:
                                    viewModel.editingStockQuantity ?? 0,
                                categoryId: viewModel.editingCategoryId ?? 0,
                              )
                            : await viewModel.createProduct(
                                productName: viewModel.editingProductName ?? '',
                                price: viewModel.editingPrice ?? 0,
                                stockQuantity:
                                    viewModel.editingStockQuantity ?? 0,
                                categoryId: viewModel.editingCategoryId ?? 0,
                              );
                        if (success && context.mounted) {
                          m.Navigator.of(context).pop();
                        } else if (!success &&
                            context.mounted &&
                            viewModel.productError != null) {
                          m.ScaffoldMessenger.of(context).showSnackBar(
                            m.SnackBar(
                              content: m.Text(viewModel.productError!),
                              backgroundColor: m.Colors.red,
                            ),
                          );
                        }
                      },
                      child: m.Text(isEditing ? 'Lưu thay đổi' : 'Tạo mới'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirm(
    m.BuildContext context,
    AdminProductViewModel viewModel,
    int id,
  ) {
    m.showDialog(
      context: context,
      builder: (context) => m.Dialog(
        backgroundColor: m.Colors.transparent,
        child: m.Container(
          width: 400,
          padding: const m.EdgeInsets.all(24),
          decoration: m.BoxDecoration(
            color: m.Colors.white,
            borderRadius: m.BorderRadius.circular(20),
            boxShadow: [
              m.BoxShadow(
                color: m.Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const m.Offset(0, 10),
              ),
            ],
          ),
          child: m.Column(
            mainAxisSize: m.MainAxisSize.min,
            children: [
              m.Container(
                padding: const m.EdgeInsets.all(16),
                decoration: m.BoxDecoration(
                  color: const m.Color(0xFFFEF2F2),
                  shape: m.BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.triangleAlert,
                  color: m.Color(0xFFEF4444),
                  size: 32,
                ),
              ),
              const m.SizedBox(height: 16),
              m.Text(
                'Xóa sản phẩm?',
                style: Theme.of(context).typography.h4.copyWith(
                  fontWeight: m.FontWeight.w700,
                  color: const m.Color(0xFF0F172A),
                ),
                textAlign: m.TextAlign.center,
              ),
              const m.SizedBox(height: 8),
              m.Text(
                'Hành động này không thể hoàn tác. Dữ liệu của sản phẩm này sẽ bị xóa vĩnh viễn khỏi hệ thống.',
                style: Theme.of(context).typography.small.copyWith(
                  color: const m.Color(0xFF64748B),
                  height: 1.5,
                ),
                textAlign: m.TextAlign.center,
              ),
              const m.SizedBox(height: 32),
              m.Row(
                children: [
                  m.Expanded(
                    child: OutlineButton(
                      onPressed: () => m.Navigator.of(context).pop(),
                      child: const m.Text('Trở về'),
                    ),
                  ),
                  const m.SizedBox(width: 12),
                  m.Expanded(
                    child: DestructiveButton(
                      onPressed: () async {
                        final success = await viewModel.deleteProduct(id);
                        if (success && context.mounted) {
                          m.Navigator.of(context).pop();
                        } else if (!success &&
                            context.mounted &&
                            viewModel.productError != null) {
                          m.ScaffoldMessenger.of(context).showSnackBar(
                            m.SnackBar(
                              content: m.Text(viewModel.productError!),
                              backgroundColor: m.Colors.red,
                            ),
                          );
                        }
                      },
                      child: const m.Text('Xóa ngay'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  m.Widget _buildCategoriesTab() {
    return Consumer<AdminProductViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoadingCategories) {
          return const m.Center(child: m.CircularProgressIndicator());
        }

        return m.Column(
          children: [
            m.Padding(
              padding: const m.EdgeInsets.all(16),
              child: PrimaryButton(
                onPressed: () => _showCategoryDialog(context, viewModel),
                child: m.Row(
                  mainAxisAlignment: m.MainAxisAlignment.center,
                  children: const [
                    Icon(LucideIcons.plus, size: 18),
                    m.SizedBox(width: 8),
                    m.Text('Thêm Danh mục mới'),
                  ],
                ),
              ),
            ),
            m.Expanded(
              child: viewModel.categories.isEmpty
                  ? const m.Center(child: m.Text('Chưa có danh mục nào.'))
                  : m.ListView.builder(
                      padding: const m.EdgeInsets.symmetric(horizontal: 16),
                      itemCount: viewModel.categories.length,
                      itemBuilder: (context, index) {
                        final category = viewModel.categories[index];

                        final theme = Theme.of(context);

                        return m.Container(
                          margin: const m.EdgeInsets.only(bottom: 12),
                          decoration: m.BoxDecoration(
                            color: m.Colors.white,
                            borderRadius: m.BorderRadius.circular(16),
                            boxShadow: [
                              m.BoxShadow(
                                color: m.Colors.black.withValues(alpha: 0.03),
                                blurRadius: 8,
                                offset: const m.Offset(0, 2),
                              ),
                            ],
                          ),
                          child: m.Padding(
                            padding: const m.EdgeInsets.all(16),
                            child: m.Row(
                              children: [
                                m.Container(
                                  padding: const m.EdgeInsets.all(12),
                                  decoration: m.BoxDecoration(
                                    color: const m.Color(
                                      0xFFF0FDF4,
                                    ), // Light green
                                    shape: m.BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    LucideIcons.folder,
                                    color: m.Color(0xFF16A34A),
                                    size: 24,
                                  ),
                                ),
                                const m.SizedBox(width: 16),
                                m.Expanded(
                                  child: m.Column(
                                    crossAxisAlignment:
                                        m.CrossAxisAlignment.start,
                                    children: [
                                      m.Text(
                                        category.categoryName,
                                        style: theme.typography.base.copyWith(
                                          fontWeight: m.FontWeight.w700,
                                          color: const m.Color(0xFF0F172A),
                                        ),
                                      ),
                                      const m.SizedBox(height: 4),
                                      m.Text(
                                        category.description?.isNotEmpty == true
                                            ? category.description!
                                            : 'Không có mô tả',
                                        style: theme.typography.small.copyWith(
                                          color: const m.Color(0xFF64748B),
                                          fontStyle:
                                              category
                                                      .description
                                                      ?.isNotEmpty ==
                                                  true
                                              ? m.FontStyle.normal
                                              : m.FontStyle.italic,
                                        ),
                                        maxLines: 2,
                                        overflow: m.TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                m.Row(
                                  mainAxisSize: m.MainAxisSize.min,
                                  children: [
                                    m.IconButton(
                                      icon: const Icon(
                                        LucideIcons.pencil,
                                        size: 18,
                                        color: m.Color(0xFF334155),
                                      ),
                                      onPressed: () => _showCategoryDialog(
                                        context,
                                        viewModel,
                                        category: category,
                                      ),
                                    ),
                                    m.IconButton(
                                      icon: const Icon(
                                        LucideIcons.trash2,
                                        size: 18,
                                        color: m.Color(0xFFEF4444),
                                      ),
                                      onPressed: () =>
                                          _showDeleteCategoryConfirm(
                                            context,
                                            viewModel,
                                            category.id,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  void _showCategoryDialog(
    m.BuildContext context,
    AdminProductViewModel viewModel, {
    Category? category,
  }) {
    final isEditing = category != null;

    if (isEditing) {
      viewModel.setCategoryEditMode(category);
    } else {
      viewModel.setCategoryCreateMode();
    }

    m.showDialog(
      context: context,
      builder: (context) => m.Dialog(
        backgroundColor: m.Colors.transparent,
        child: m.Container(
          width: 400,
          padding: const m.EdgeInsets.all(24),
          decoration: m.BoxDecoration(
            color: m.Colors.white,
            borderRadius: m.BorderRadius.circular(20),
            boxShadow: [
              m.BoxShadow(
                color: m.Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const m.Offset(0, 10),
              ),
            ],
          ),
          child: m.SingleChildScrollView(
            child: m.Column(
              mainAxisSize: m.MainAxisSize.min,
              crossAxisAlignment: m.CrossAxisAlignment.start,
              children: [
                m.Row(
                  mainAxisAlignment: m.MainAxisAlignment.spaceBetween,
                  children: [
                    m.Text(
                      isEditing ? 'Sửa Danh mục' : 'Thêm Danh mục',
                      style: Theme.of(context).typography.h4.copyWith(
                        fontWeight: m.FontWeight.w700,
                        color: const m.Color(0xFF0F172A),
                      ),
                    ),
                    m.IconButton(
                      icon: const Icon(
                        LucideIcons.x,
                        size: 20,
                        color: m.Color(0xFF64748B),
                      ),
                      onPressed: () => m.Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const m.SizedBox(height: 24),
                m.Text(
                  'TÊN DANH MỤC',
                  style: Theme.of(context).typography.small.copyWith(
                    fontWeight: m.FontWeight.w600,
                    color: const m.Color(0xFF64748B),
                    letterSpacing: 0.5,
                  ),
                ),
                const m.SizedBox(height: 8),
                TextField(
                  controller: m.TextEditingController(
                    text: viewModel.editingCategoryName,
                  ),
                  placeholder: const m.Text('Ví dụ: Cây trong nhà...'),
                  onChanged: (v) => viewModel.setCategoryNameInput(v),
                ),
                const m.SizedBox(height: 16),
                m.Text(
                  'MÔ TẢ CHI TIẾT',
                  style: Theme.of(context).typography.small.copyWith(
                    fontWeight: m.FontWeight.w600,
                    color: const m.Color(0xFF64748B),
                    letterSpacing: 0.5,
                  ),
                ),
                const m.SizedBox(height: 8),
                TextField(
                  controller: m.TextEditingController(
                    text: viewModel.editingCategoryDescription,
                  ),
                  placeholder: const m.Text('Thông tin về danh mục...'),
                  minLines: 3,
                  maxLines: 5,
                  onChanged: (v) => viewModel.setCategoryDescriptionInput(v),
                ),
                const m.SizedBox(height: 32),
                m.Row(
                  mainAxisAlignment: m.MainAxisAlignment.end,
                  children: [
                    OutlineButton(
                      onPressed: () => m.Navigator.of(context).pop(),
                      child: const m.Text('Hủy'),
                    ),
                    const m.SizedBox(width: 12),
                    PrimaryButton(
                      onPressed: () async {
                        if (viewModel.editingCategoryName == null ||
                            viewModel.editingCategoryName!.isEmpty) {
                          return; // Validation cơ bản
                        }

                        viewModel.clearError();
                        final success = isEditing
                            ? await viewModel.updateCategory(
                                id: category.id,
                                categoryName: viewModel.editingCategoryName!,
                                description:
                                    viewModel.editingCategoryDescription,
                              )
                            : await viewModel.createCategory(
                                categoryName: viewModel.editingCategoryName!,
                                description:
                                    viewModel.editingCategoryDescription,
                              );

                        if (success && context.mounted) {
                          m.Navigator.of(context).pop();
                        } else if (!success &&
                            context.mounted &&
                            viewModel.productError != null) {
                          m.ScaffoldMessenger.of(context).showSnackBar(
                            m.SnackBar(
                              content: m.Text(viewModel.productError!),
                              backgroundColor: m.Colors.red,
                            ),
                          );
                        }
                      },
                      child: m.Text(isEditing ? 'Cập nhật' : 'Tạo mới'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteCategoryConfirm(
    m.BuildContext context,
    AdminProductViewModel viewModel,
    int id,
  ) {
    m.showDialog(
      context: context,
      builder: (context) => m.Dialog(
        backgroundColor: m.Colors.transparent,
        child: m.Container(
          width: 400,
          padding: const m.EdgeInsets.all(24),
          decoration: m.BoxDecoration(
            color: m.Colors.white,
            borderRadius: m.BorderRadius.circular(20),
            boxShadow: [
              m.BoxShadow(
                color: m.Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const m.Offset(0, 10),
              ),
            ],
          ),
          child: m.Column(
            mainAxisSize: m.MainAxisSize.min,
            children: [
              m.Container(
                padding: const m.EdgeInsets.all(16),
                decoration: m.BoxDecoration(
                  color: const m.Color(0xFFFEF2F2),
                  shape: m.BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.triangleAlert,
                  color: m.Color(0xFFEF4444),
                  size: 32,
                ),
              ),
              const m.SizedBox(height: 16),
              m.Text(
                'Xóa Danh mục?',
                style: Theme.of(context).typography.h4.copyWith(
                  fontWeight: m.FontWeight.w700,
                  color: const m.Color(0xFF0F172A),
                ),
                textAlign: m.TextAlign.center,
              ),
              const m.SizedBox(height: 8),
              m.Text(
                'Hành động này không thể hoàn tác. Hãy chắn chắn rằng không có sản phẩm nào đang thuộc danh mục này.',
                style: Theme.of(context).typography.small.copyWith(
                  color: const m.Color(0xFF64748B),
                  height: 1.5,
                ),
                textAlign: m.TextAlign.center,
              ),
              const m.SizedBox(height: 32),
              m.Row(
                children: [
                  m.Expanded(
                    child: OutlineButton(
                      onPressed: () => m.Navigator.of(context).pop(),
                      child: const m.Text('Trở về'),
                    ),
                  ),
                  const m.SizedBox(width: 12),
                  m.Expanded(
                    child: DestructiveButton(
                      onPressed: () async {
                        final success = await viewModel.deleteCategory(id);
                        if (success && context.mounted) {
                          m.Navigator.of(context).pop();
                        } else if (!success &&
                            context.mounted &&
                            viewModel.productError != null) {
                          m.ScaffoldMessenger.of(context).showSnackBar(
                            m.SnackBar(
                              content: m.Text(viewModel.productError!),
                              backgroundColor: m.Colors.red,
                            ),
                          );
                        }
                      },
                      child: const m.Text('Xóa ngay'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
