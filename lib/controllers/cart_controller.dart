
import 'package:get/get.dart';
import '../models/product.dart';

class CartController extends GetxController {
  final RxList<Product> items = <Product>[].obs;

  // Menambahkan produk ke keranjang
  void addToCart(Product product) {
    items.add(product);
  }

  // Menghitung jumlah seluruh barang
  int get totalItem => items.length;

  // Menghitung harga satu produk,
  // termasuk harga setelah diskon
  double hargaProduk(Product product) {
    if (product is DiscountedProduct) {
      return product.hargaFinal().toDouble();
    }

    return product.price.toDouble();
  }

  // Menghitung total harga seluruh barang
  double get totalHarga {
    return items.fold<double>(
      0,
      (total, product) => total + hargaProduk(product),
    );
  }

  // Mengambil daftar produk unik untuk tampilan keranjang
  List<Product> get uniqueItems {
    final List<Product> hasil = [];

    for (final product in items) {
      final sudahAda = hasil.any(
        (item) => item.id == product.id,
      );

      if (!sudahAda) {
        hasil.add(product);
      }
    }

    return hasil;
  }

  // Menghitung quantity produk berdasarkan ID
  int quantityOf(Product product) {
    return items.where(
      (item) => item.id == product.id,
    ).length;
  }

  // Menambah quantity satu produk
  void increaseQuantity(Product product) {
    addToCart(product);
  }

  // Mengurangi quantity satu produk
  void decreaseQuantity(Product product) {
    final index = items.lastIndexWhere(
      (item) => item.id == product.id,
    );

    if (index != -1) {
      items.removeAt(index);
    }
  }

  // Menghapus seluruh quantity dari satu jenis produk
  void removeFromCart(Product product) {
    items.removeWhere(
      (item) => item.id == product.id,
    );
  }

  // Mengosongkan seluruh keranjang
  void clearCart() {
    items.clear();
  }

  // Menghitung subtotal satu jenis produk
  double subtotal(Product product) {
    return hargaProduk(product) * quantityOf(product);
  }
}