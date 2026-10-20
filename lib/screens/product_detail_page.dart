import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product.dart';
import '../controllers/cart_controller.dart';
import '../services/product_services.dart';

class ProductDetailPage extends StatefulWidget {
  final Product? product;
  final int? productId;

  const ProductDetailPage({
    super.key,
    this.product,
    this.productId,
  }) : assert(
          product != null || productId != null,
          'product atau productId harus diisi',
        );

  @override
  State<ProductDetailPage> createState() =>
      _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int jumlah = 1;

  late final CartController cartController;
  late Future<Product> futureProduct;

  final ProductService productService = ProductService();

  @override
  void initState() {
    super.initState();

    cartController = Get.find<CartController>();

    if (widget.product != null) {
      // Menggunakan produk yang dikirim melalui navigasi.
      futureProduct = Future.value(widget.product!);
    } else {
      // Mengambil detail produk langsung dari API.
      futureProduct = productService.fetchProductDetail(
        widget.productId!,
      );
    }
  }

  void retryFetchProduct() {
    final int id = widget.productId ?? widget.product!.id;

    setState(() {
      futureProduct = productService.fetchProductDetail(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text('Detail Produk'),
      ),
      body: FutureBuilder<Product>(
        future: futureProduct,
        builder: (context, snapshot) {
          // 1. Menampilkan loading ketika data sedang diambil.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // 2. Menampilkan pesan jika pengambilan data gagal.
          if (snapshot.hasError || !snapshot.hasData) {
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
                      'Gagal memuat detail produk.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: retryFetchProduct,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          // 3. Data sudah tersedia dan aman digunakan.
          final Product product = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.image,
                    size: 80,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Rp ${product.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Text('Kategori: ${product.category}'),

                const SizedBox(height: 8),

                Text(
                  'Status Stok: ${product.getStatusStok()}',
                ),

                const SizedBox(height: 16),

                const Text(
                  'Deskripsi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  product.description ?? 'Tidak ada deskripsi.',
                ),

                const SizedBox(height: 24),

                const Text(
                  'Jumlah',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (jumlah > 1) {
                          setState(() {
                            jumlah--;
                          });
                        }
                      },
                      icon: const Icon(Icons.remove),
                    ),

                    Text(
                      '$jumlah',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        setState(() {
                          jumlah++;
                        });
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (product.stock <= 0) {
                        Get.snackbar(
                          'Stok Habis',
                          'Produk ini tidak tersedia.',
                        );
                        return;
                      }

                      if (jumlah > product.stock) {
                        Get.snackbar(
                          'Stok Tidak Mencukupi',
                          'Jumlah pembelian melebihi stok produk.',
                        );
                        return;
                      }

                      for (int i = 0; i < jumlah; i++) {
                        cartController.addToCart(product);
                      }

                      Get.snackbar(
                        'Berhasil',
                        '$jumlah item ditambahkan ke keranjang.',
                      );

                      Get.back();
                    },
                    child: const Text('Tambah ke Keranjang'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}