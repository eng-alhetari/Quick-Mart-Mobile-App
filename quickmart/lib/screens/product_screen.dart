import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:quickmart/providers/product_provider.dart';
import 'package:quickmart/providers/category_provider.dart';
import 'package:quickmart/routes/app_router.dart';
import 'package:quickmart/widgits/product_card.dart';
import 'dart:async';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    // Fetch all products and categories on initial load
    ref.read(productNotifierProvider.notifier).fetchProducts();
    ref.read(categoryNotifierProvider.notifier).fetchCategories();
  }

  Future<void> _filterProducts() async {
    if (_selectedCategory == 'All') {
      await ref.read(productNotifierProvider.notifier).fetchProducts();
    } else {
      await ref.read(productNotifierProvider.notifier).filterProductsByCategory(_selectedCategory);
    }
  }

  Future<void> _searchProducts() async {
    if (_searchQuery.isEmpty) {
      await _filterProducts();
    } else {
      await ref.read(productNotifierProvider.notifier).searchProducts(_searchQuery);
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productNotifierProvider);
    final categories = ref.watch(categoryNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) async {
                      setState(() {
                        _searchQuery = value;
                      });
                      await _searchProducts();
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.blueGrey[50],
                      filled: true,
                      prefixIcon: const Icon(Icons.search),
                      labelText: 'Search',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  icon: const FaIcon(
                    FontAwesomeIcons.sliders,
                    size: 30,
                    color: Colors.green,
                  ),
                  value: _selectedCategory,
                  items: [
                    const DropdownMenuItem(value: 'All', child: Text('All')),
                    if (categories.isNotEmpty)
                      ...categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                  ],
                  onChanged: (value) async {
                    if (value != null) {
                      setState(() {
                        _selectedCategory = value;
                      });
                      await _filterProducts();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: products.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return GestureDetector(
                          onTap: () {
                            context.pushNamed(AppRouter.product.name, extra: product);
                          },
                          child: ProductCard(product: product),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
