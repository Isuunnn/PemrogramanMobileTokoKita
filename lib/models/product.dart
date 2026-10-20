
class Product {
  final int id;
  final String name;
  final double price;
  final String imageUrl;
  final String category;
  final int stock;
  final String? description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.stock,
    this.description,
  });

  // BARU: Mengubah data JSON API menjadi objek Product
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: (json['id'] as num).toInt(),
      name: json['title'] as String? ?? 'Produk',
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image'] as String? ?? '',
      category: json['category'] as String? ?? 'Lainnya',
      stock: 10,
      description: json['description'] as String?,
    );
  }

  String getInfo() {
    return '$name - Rp ${price.toStringAsFixed(0)} - Stok: $stock';
  }

  String getStatusStok() {
    if (stock == 0) {
      return 'Habis';
    } else if (stock <= 5) {
      return 'Stok Terbatas';
    } else {
      return 'Tersedia';
    }
  }
}

class DiscountedProduct extends Product {
  final double discountPercent;

  DiscountedProduct({
    required super.id,
    required super.name,
    required super.price,
    required super.imageUrl,
    required super.category,
    required super.stock,
    super.description,
    required this.discountPercent,
  });

  double hargaFinal() {
    return price - (price * discountPercent / 100);
  }
}
