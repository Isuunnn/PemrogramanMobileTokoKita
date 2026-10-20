
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../models/product.dart';
import 'main_page.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        final products = controller.uniqueItems;

        if (controller.items.isEmpty) {
          return const Center(
            child: Text('Tidak ada pesanan untuk ditampilkan.'),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'Ringkasan Pesanan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  ...products.map((Product product) {
                    final quantity =
                        controller.quantityOf(product);

                    return Card(
                      child: ListTile(
                        title: Text(product.name),
                        subtitle: Text(
                          '${quantity} barang × Rp '
                          '${controller.hargaProduk(product).toStringAsFixed(0)}',
                        ),
                        trailing: Text(
                          'Rp ${controller.subtotal(product).toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 16),
                  const Divider(),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Pembayaran',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Rp ${controller.totalHarga.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    controller.clearCart();

                    Get.offAll(
                      () => const MainPage(),
                    );

                    Get.snackbar(
                      'Pesanan Berhasil',
                      'Pesanan berhasil diselesaikan.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  child: const Text('Selesaikan Pesanan'),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}