import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  static const String apiUrl =
      'https://fakestoreapi.com/products';

  Future<Product> fetchProductDetail(int id) async {
  try {
    final response = await http.get(
      Uri.parse('$apiUrl/$id'),
    );

    debugPrint(
      'Detail Product Status Code: ${response.statusCode}',
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mengambil detail produk. '
        'Status code: ${response.statusCode}',
      );
    }

    final Map<String, dynamic> jsonData =
        jsonDecode(response.body) as Map<String, dynamic>;

    return Product.fromJson(jsonData);
  } catch (error) {
    debugPrint('Error fetchProductDetail: $error');
    rethrow;
  }
}

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
      );

      // Menampilkan response di Debug Console
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception(
          'Gagal mengambil produk. '
          'Status code: ${response.statusCode}',
        );
      }

      // Mengubah JSON menjadi List
      final List<dynamic> jsonData =
          jsonDecode(response.body) as List<dynamic>;

      // Mengubah setiap data JSON menjadi Product
      final List<Product> products = jsonData.map((item) {
        return Product.fromJson(
          item as Map<String, dynamic>,
        );
      }).toList();

      return products;
    } catch (error) {
      debugPrint('Error fetchProducts: $error');

      // Diteruskan agar FutureBuilder bisa membaca error
      rethrow;
    }
  }
}