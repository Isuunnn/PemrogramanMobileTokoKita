import 'package:flutter/material.dart';

import '../models/product.dart';
import '../widgets/product_card.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../services/product_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  late final CartController cartController;

  late Future<List<Product>> futureProducts;
  final ProductService productService = ProductService();

  String selectedCategory = 'Semua';

  @override
  void initState() {
    super.initState();
    cartController = Get.find<CartController>();
    futureProducts = productService.fetchProducts();
  }
  Future<void> refreshProducts() async {
    final newFuture = productService.fetchProducts();
    setState(() {
    futureProducts = newFuture;
  });

  await newFuture;
  }

  final Map<String, String?> categories = {
  'Semua': null,
  'Elektronik': 'electronics',
  'Perhiasan': 'jewelery',
  'Pakaian Pria': "men's clothing",
  'Pakaian Wanita': "women's clothing",
};

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TokoKita',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Belanja jadi lebih mudah',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  IconButton(
                    onPressed: () {
                      // Pindah ke tab Keranjang pada MainPage.
                      // Jika belum memiliki callback perpindahan tab,
                      // kamu bisa menggunakan SnackBar sementara.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Keranjang belanja'),
                        ),
                      );
                    },
                    icon: Obx(
                      () => Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(
                            Icons.shopping_cart_outlined,
                            size: 28,
                          ),
                          if (cartController.totalItem > 0)
                            Positioned(
                              right: -8,
                              top: -8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 18,
                                  minHeight: 18,
                                ),
                                child: Text(
                                  '${cartController.totalItem}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),

            // CATEGORY
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: categories.keys.map((category) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: selectedCategory == category,
                        onSelected: (_) {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

            const SizedBox(height: 8),

            // PRODUCT LIST
            Expanded(
              child: RefreshIndicator(
                onRefresh: refreshProducts,
                child: FutureBuilder<List<Product>>(
                  future: futureProducts,
                  builder: (context, snapshot) {
                  // Saat data sedang dimuat
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  // Jika terjadi error
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Gagal memuat produk, coba lagi',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  futureProducts =
                                      productService.fetchProducts();
                                });
                              },
                              child: const Text('Coba Lagi'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Jika data berhasil dimuat
                  final products = snapshot.data ?? <Product>[];

                  final categoryApi = categories[selectedCategory];

                  final filteredProducts = categoryApi == null
                      ? products
                      : products
                          .where(
                            (product) => product.category == categoryApi,
                          )
                          .toList();

                  // Jika tidak ada produk
                  if (filteredProducts.isEmpty) {
                    return const Center(
                      child: Text('Tidak ada produk pada kategori ini'),
                    );
                  }

                  // Menampilkan produk
                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];

                      return ProductCard(
                        key: ValueKey(product.id),
                        product: product,
                      );
                    },
                  );
                },
              ),
            )),
          ],
        ),
      ),
    );
  }
}